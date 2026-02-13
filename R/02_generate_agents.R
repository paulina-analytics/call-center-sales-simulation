# ======================================
# 02_generate_agents.R
# ======================================
# Generate sales agents
# ======================================

set.seed(456)

library(dplyr)

n_agents <- 200

agents <- tibble(
  agent_id = 1:n_agents,
  
  experience_months = round(
    pmax(rnorm(n_agents, mean = 24, sd = 18), 1)
  ),
  
  hourly_cost = round(
    rnorm(n_agents, mean = 45, sd = 8)
  )
) %>%
  mutate(
    # Ability to close agreements
    closing_skill = pmin(
      0.3 + experience_months / 120 + runif(n_agents, 0, 0.2),
      0.9
    ),
    
    # Tendency to ignore credit risk
    risk_blindness = runif(n_agents, 0.2, 1)
  )


