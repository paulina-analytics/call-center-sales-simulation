# ======================================
# 01_generate_clients.R
# ======================================

set.seed(123)
library(dplyr)

n_clients <- 50000

clients <- tibble(
  client_id = 1:n_clients,
  age = round(pmin(pmax(rnorm(n_clients, 38, 12), 18), 72)),
  employment_type = sample(
    c("permanent_contract", "temporary_contract", "self_employed", "unemployed"),
    n_clients, TRUE, c(0.45, 0.25, 0.20, 0.10)
  ),
  monthly_income = round(rlnorm(n_clients, log(5000), 0.4)),
  obligations = sample(c(0,1,2,3), n_clients, TRUE, c(0.35,0.30,0.20,0.15))
)

clients <- clients %>%
  mutate(
    credit_score = 100 -
      if_else(employment_type=="unemployed",50,0) -
      if_else(employment_type=="temporary_contract",20,0) -
      if_else(employment_type=="self_employed",15,0) -
      case_when(
        monthly_income < 3500 ~ 25,
        monthly_income < 4500 ~ 15,
        monthly_income < 6000 ~ 5,
        TRUE ~ 0
      ) -
      obligations * 10 -
      if_else(age < 23, 10, 0),
    credit_score = pmax(pmin(credit_score,100),0)
  )


