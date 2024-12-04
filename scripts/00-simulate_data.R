#### Preamble ####
# Purpose: Simulates a survey dataset of 60,000 respondents from across the United States containing
# questions about demographics, past vote, and voting intentions for the 2022 midterms (or lack thereof)
# Author: Talia Fabregas
# Date: December 1, 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: The tidyverse, janitor, and arrow packages must be installed
# Any other information needed? Make sure you are in the `US-Midterms-2022` rproj


#### Workspace setup ####
library(tidyverse)
library(janitor)
library(arrow)
set.seed(222)

num_simulations <- 60000

# List of all 50 states in alphabetical order


states <- c(
  "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
  "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho",
  "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine",
  "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi",
  "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey",
  "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio",
  "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
  "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia",
  "Washington", "West Virginia", "Wisconsin", "Wyoming"
)

# # proportion of population in each state based on census.
# # I used ChatGPT to generate this
state_pop_proportions <- c(
  0.0147, 0.0027, 0.0216, 0.0090, 0.1198, 0.0170, 0.0107, 0.0032, 0.0611, 0.0316,
  0.0044, 0.0058, 0.0386, 0.0202, 0.0098, 0.0085, 0.0134, 0.0144, 0.0045, 0.0185,
  0.0201, 0.0302, 0.0171, 0.0089, 0.0193, 0.0035, 0.0056, 0.0095, 0.0043, 0.0282,
  0.0063, 0.0593, 0.0313, 0.0077, 0.0374, 0.0153, 0.0128, 0.0386, 0.0032, 0.0238,
  0.0061, 0.0217, 0.0877, 0.0092, 0.0058, 0.0255, 0.0245, 0.0052, 0.0180, 0.0059
)
#
#
genders_binary <- c("male", "female")

races <- c("white","black", "asian", "middle eastern", "native american",
           "hispanic", "pacific islander", "other", "chinese", "japanese",
           "asian", "south asian")

party_id <- c("Democrat", "Republican", "Green", "Libertarian", "Independent")

candidates2020 <- c("Joe Biden", "Donald Trump", "Other")

is_registered <- c("Yes", "No")

vote_2022_midterms <- c("Yes", "No")

congress_vote <- c("Democratic", "Republican", "Other", "Not voting in congressional race")

senate_vote <- c("Democratic", "Republican", "Other", "Not voting in US Senate race")

government_trust_options <- c("High level of trust", "Some trust", "Low trust", "None at all")

know_us_house_options <- c("Yes", "No")

#### Simulate data ####
# State names


simulated_data <- tibble(
  respondent_id = 1:num_simulations,
  state = sample(
    states,
    size = num_simulations,
    replace = TRUE,
    prob = state_pop_proportions
  ),
  age = sample(18:99,
               size=num_simulations,
               replace=TRUE),
  gender = sample(
    genders_binary,
    size = num_simulations,
    replace = TRUE,
    prob = c(0.5, 0.5)
  ),
  race = sample(races,
                size = num_simulations,
                replace = TRUE),
  vote_2020 = sample(
    candidates2020,
    size = num_simulations,
    replace=TRUE,
    prob = c(0.513, 0.468, 0.019)
  ),
  registered_voter = sample(
    0:1,
    size = num_simulations,
    replace=TRUE,
    prob = c(0.32, 0.68)
  ),
  voted_in_2022 = sample(
    vote_2022_midterms,
    size = num_simulations,
    replace = TRUE
  ),
  preferred_senate = sample(
    senate_vote,
    size = num_simulations,
    replace = TRUE
  ),
  preferred_congress = sample(
    congress_vote,
    size = num_simulations,
    replace = TRUE
  ),
  govt_trust = sample(
    government_trust_options,
    size = num_simulations,
    replace = TRUE
  ),
  know_us_house = sample(
    know_us_house_options,
    size = num_simulations,
    replace = TRUE
  )
)



#### Save data ####
write_parquet(simulated_data, "data/00-simulated_data/simulated_data.parquet")