# ======================================
# 04_visualizations.R — CLEAN
# ======================================

stopifnot(exists("call_attempts"))

library(dplyr)
library(tidyr)    # <-- TO BYŁ BRAKUJĄCY ELEMENT
library(ggplot2)
library(scales)

# ----------------------
# Strategy comparison
# ----------------------

strategy_summary <- call_attempts %>%
  summarise(
    `Human only`    = mean(profit_human, na.rm = TRUE),
    `AI only`       = mean(profit_ai, na.rm = TRUE),
    `Random 50/50`  = mean(profit_random, na.rm = TRUE),
    `Smart routing` = mean(profit_final, na.rm = TRUE)
  ) %>%
  pivot_longer(
    cols = everything(),
    names_to = "strategy",
    values_to = "avg_profit"
  )

p_strategy <- ggplot(strategy_summary, aes(x = strategy, y = avg_profit)) +
  geom_col(fill = "steelblue", width = 0.6) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey40") +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Average profit per call by routing strategy",
    subtitle = "Comparison on the same simulated world",
    x = NULL,
    y = "Average profit per call"
  ) +
  theme_minimal(base_size = 13)

p_strategy

# ----------------------
# Relative advantage distribution
# ----------------------

p_delta <- ggplot(
  call_attempts %>% filter(delta_profit > -100, delta_profit < 300),
  aes(x = delta_profit)
) +
  geom_histogram(bins = 60, fill = "darkorange", alpha = 0.7) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Relative advantage of Human vs AI (zoomed)",
    subtitle = "Most calls show small differences; few outliers drive large gains",
    x = "Profit difference (Human − AI)",
    y = "Number of calls"
  ) +
  theme_minimal(base_size = 13)

p_delta



# ----------------------
# Routing decision visualization
# ----------------------

p_routing <- ggplot(
  call_attempts %>%
    filter(
      handled_by %in% c("AI", "Human"),
      delta_profit > -100,
      delta_profit < 300
    ),
  aes(x = delta_profit, fill = handled_by)
) +
  geom_density(alpha = 0.5) +
  geom_vline(xintercept = 0, linetype = "dashed") +
  labs(
    title = "Smart routing based on relative advantage (zoomed)",
    subtitle = "AI handles calls where it performs close to Human",
    x = "Profit difference (Human − AI)",
    y = "Density",
    fill = "Handled by"
  ) +
  theme_minimal(base_size = 13)

p_routing

