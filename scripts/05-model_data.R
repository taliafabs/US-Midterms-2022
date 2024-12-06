#### Preamble ####
# Purpose: Models the probability that someone who voted for Trump or Biden in the 2020 U.S. Presidential
# Election would also vote in the 2022 Midterm Elections
# Author: Talia Fabregas
# Date: December 1, 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Run 02-download_data.R and 03-clean_data.R
# - Ensure that the tidyverse, arrow, tidymodels, and rstanarm packages are installed
# Any other information needed? No


#### Workspace setup ####
library(tidyverse)
library(arrow)
library(tidymodels)
library(rstanarm)

#### Read data ####
# build a prediction-focused logistic regression model using validation set approach
# predicting the probability that someone who voted in the 2020 U.S. presidential election would also vote in the 2022 midterms

ces22_analysis_data <- read_parquet("data/02-analysis_data/ces2022_analysis_data.parquet")

ces22_analysis_data <- 
  ces22_analysis_data |>
  mutate(voted_in_2022 = as_factor(voted_in_2022)) |>
  mutate(voted_for_trump = as_factor(voted_for_trump))

set.seed(538)

ces_2022_reduced <- 
  ces22_analysis_data |>
  slice_sample(n = 7500)

# uses presvote20post, educ, and stuff about trust/engagement to predict whether or not someone voted in midterms

turnout_model_2022 <- 
  stan_glm(
    voted_in_2022 ~ presvote2020 + age_bracket + educ + know_us_house + know_us_senate + trustfed + truststate + political_interest,
    data = ces_2022_reduced,
    family = binomial(link="logit"),
    weights = commonpostweight,
    prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
    prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
    seed = 538
  )

political_preferences <- stan_glm(
  voted_for_trump ~ age_bracket + gender + race + educ + trustfed + know_us_house,
  data = ces_2022_reduced,
  family = binomial(link="logit"),
  weights = commonweight,
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  seed = 538
)


#### Save model ####
saveRDS(
  turnout_model_2022,
  file = "models/turnout_model_2022.rds"
)

saveRDS(
  political_preferences,
  file = "models/political_preference_model.rds"
)



