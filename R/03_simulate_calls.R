# ======================================
# 03_simulate_calls.R — CLEAN & STABLE
# ======================================

stopifnot(exists("clients"), exists("agents"))

library(dplyr)
library(purrr)

set.seed(789)

# ----------------------
# Configuration
# ----------------------

work_days <- 60
calls_per_agent_per_day <- 60
avg_call_minutes <- 12
contract_months <- 24
real_phone_cost <- 800

# AI assumptions
ai_hourly_cost <- 2
ai_call_minutes <- 6
ai_closing_penalty <- 0.6

# ----------------------
# Strategy evaluation
# ----------------------

evaluate_strategy <- function(
    latent_draw,
    base_prob,
    closing_multiplier,
    call_minutes,
    hourly_cost,
    revenue,
    phone_cost
) {
  
  agreement <- as.integer(
    latent_draw < pmin(base_prob * closing_multiplier, 0.95)
  )
  
  cost <- call_minutes / 60 * hourly_cost
  
  profit <- if_else(
    agreement == 1,
    revenue - cost - phone_cost,
    -cost
  )
  
  profit
}

# ----------------------
# Time slots
# ----------------------

time_slots <- tibble(
  time_slot = c("morning", "midday", "peak", "evening"),
  contact_rate = c(0.25, 0.45, 0.70, 0.40)
)

# ----------------------
# Generate call attempts
# ----------------------

call_attempts <- expand.grid(
  agent_id = agents$agent_id,
  day = 1:work_days,
  call_nr = 1:calls_per_agent_per_day
) %>%
  as_tibble()

# ----------------------
# Time slot & contact
# ----------------------

call_attempts <- call_attempts %>%
  mutate(
    time_slot = sample(
      time_slots$time_slot,
      n(),
      replace = TRUE,
      prob = c(0.25, 0.30, 0.25, 0.20)
    )
  ) %>%
  left_join(time_slots, by = "time_slot") %>%
  mutate(
    lead_quality = sample(
      c("poor", "average", "good"),
      n(),
      replace = TRUE,
      prob = c(0.45, 0.35, 0.20)
    ),
    adjusted_contact_rate = case_when(
      lead_quality == "poor" ~ contact_rate * 0.7,
      lead_quality == "average" ~ contact_rate,
      lead_quality == "good" ~ contact_rate * 1.2
    ),
    adjusted_contact_rate = pmin(adjusted_contact_rate, 0.95),
    answered = rbinom(n(), 1, adjusted_contact_rate)
  )

# ----------------------
# Assign clients & interest
# ----------------------

call_attempts <- call_attempts %>%
  mutate(
    client_id = if_else(
      answered == 1,
      sample(clients$client_id, n(), replace = TRUE),
      NA_integer_
    ),
    interested = if_else(answered == 1, rbinom(n(), 1, 0.35), 0),
    callback   = if_else(interested == 1, rbinom(n(), 1, 0.30), 0)
  )

# ----------------------
# Join agents
# ----------------------

call_attempts <- call_attempts %>%
  left_join(
    agents %>% select(agent_id, closing_skill, risk_blindness, hourly_cost),
    by = "agent_id"
  )

# ----------------------
# Base agreement probability
# ----------------------

call_attempts <- call_attempts %>%
  mutate(
    base_agreement_prob = if_else(
      answered == 1 & interested == 1 & callback == 0,
      0.15 + 0.5 * closing_skill + 0.2 * risk_blindness,
      0
    ),
    base_agreement_prob = pmin(base_agreement_prob, 0.95)
  )

# ----------------------
# Latent conversion potential
# ----------------------

call_attempts <- call_attempts %>%
  mutate(
    latent_conversion_draw = runif(n())
  )

# ----------------------
# Product & pricing
# ----------------------

call_attempts <- call_attempts %>%
  mutate(
    product_type = if_else(
      latent_conversion_draw < base_agreement_prob,
      sample(c("plan_with_phone", "sim_only"), n(), TRUE, c(0.9, 0.1)),
      NA_character_
    ),
    phone_price = if_else(
      product_type == "plan_with_phone",
      sample(c(1, 99, 249), n(), TRUE, c(0.7, 0.2, 0.1)),
      NA_real_
    ),
    plan_price = if_else(
      !is.na(product_type),
      sample(c(40, 70, 100), n(), TRUE, c(0.4, 0.4, 0.2)),
      NA_real_
    )
  )

# ----------------------
# Join client data
# ----------------------

call_attempts <- call_attempts %>%
  left_join(
    clients %>% select(client_id, credit_score, monthly_income, obligations),
    by = "client_id"
  )

# ----------------------
# Credit approval
# ----------------------

call_attempts <- call_attempts %>%
  mutate(
    credit_prob = case_when(
      credit_score >= 80 ~ 0.90,
      credit_score >= 65 ~ 0.70,
      credit_score >= 50 ~ 0.40,
      TRUE ~ 0.15
    ),
    credit_prob = pmax(pmin(credit_prob - obligations * 0.07, 0.95), 0.02),
    credit_approved = as.integer(runif(n()) < credit_prob)
  )

# ----------------------
# Revenue
# ----------------------

call_attempts <- call_attempts %>%
  mutate(
    revenue = if_else(
      credit_approved == 1,
      plan_price * contract_months + if_else(is.na(phone_price), 0, phone_price),
      0
    ),
    phone_cost = if_else(
      credit_approved == 1 & product_type == "plan_with_phone",
      real_phone_cost - phone_price,
      0
    )
  )

# ----------------------
# Strategy profits
# ----------------------

call_attempts <- call_attempts %>%
  mutate(
    profit_human = evaluate_strategy(
      latent_conversion_draw,
      base_agreement_prob,
      1,
      avg_call_minutes,
      hourly_cost,
      revenue,
      phone_cost
    ),
    profit_ai = evaluate_strategy(
      latent_conversion_draw,
      base_agreement_prob,
      ai_closing_penalty,
      ai_call_minutes,
      ai_hourly_cost,
      revenue,
      phone_cost
    )
  )

# ----------------------
# Relative advantage
# ----------------------

call_attempts <- call_attempts %>%
  mutate(
    delta_profit = profit_human - profit_ai
  )

# ----------------------
# Smart routing (economic)
# ----------------------

ai_cutoff <- quantile(call_attempts$delta_profit, 0.6, na.rm = TRUE)

call_attempts <- call_attempts %>%
  mutate(
    handled_by = if_else(delta_profit < ai_cutoff, "AI", "Human"),
    profit_final = if_else(handled_by == "AI", profit_ai, profit_human)
  )

# ----------------------
# Random routing baseline
# ----------------------

set.seed(999)

call_attempts <- call_attempts %>%
  mutate(
    random_route = sample(c("AI", "Human"), n(), TRUE),
    profit_random = if_else(random_route == "AI", profit_ai, profit_human)
  )
