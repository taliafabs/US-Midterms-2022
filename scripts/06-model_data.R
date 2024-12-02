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

# use presvote20post, educ, and stuff about trust/engagement to predict whether or not someone voted in midterms

### Model data ####
# ces2022_split <- initial_split(ces22_analysis_data, prop = 0.8)
# ces2022_train <- training(ces2022_split)
# ces2022_test = testing(ces2022_split)
# 
# ces_turnout_tidymodel <- 
#   logistic_reg(mode = "classification") |>
#   set_engine("glm") |>
#   fit(
#     voted_in_2022 ~ presvote2020 + age_bracket + educ + truststate + trustfed + know_us_house + know_us_senate + political_interest,
#     data = ces2022_train
#   )

turnout_model_2022 <- 
  stan_glm(
    voted_in_2022 ~ presvote2020 + age_bracket + educ + trustfed + truststate + know_us_house + political_interest,
    data = ces_2022_reduced,
    family = binomial(link="logit"),
    weights = commonweight,
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

# model for vote preference
# political_preferences <- 
#   stan_glm(
#     voted_for_trump ~ age_bracket + educ + trustfed + know_us_house + know_us_senate,
#     data = ces_2022_reduced,
#     family = binomial(link="logit"),
#     weights = commonweight,
#     prior = normal(location=0, scale=2.5, autoscale=TRUE),
#     prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
#     seed = 538
#   )


#### Save model ####
saveRDS(
  turnout_model_2022,
  file = "models/turnout_model_2022.rds"
)

saveRDS(
  political_preferences,
  file = "models/political_preference_model.rds"
)



