#### Preamble ####
# Purpose: Tests the structure and validity of the simulated election survey data
# Author: Talia Fabregas
# Date: December 1, 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
  # - The `tidyverse` package must be installed and loaded
  # - 00-simulate_data.R must have been run
# Any other information needed? Make sure you are in the `starter_folder` rproj


#### Workspace setup ####
library(tidyverse)

simulated_data <- read_parquet("data/00-simulated_data/simulated_data.parquet")

# Test if the data was successfully loaded
if (exists("simulated_data")) {
  message("Test Passed: The dataset was successfully loaded.")
} else {
  stop("Test Failed: The dataset could not be loaded.")
}


#### Test data ####

# Check that the simulated dataset has 60,000 rows
if (nrow(simulated_data) == 60000) {
  message("Test Passed: The dataset has 60,000 rows.")
} else {
  stop("Test Failed: The dataset does not have 60,000 rows.")
}

# Check that the simulated dataset has 12 variables
if (ncol(simulated_data) == 12) {
  message("Test Passed: The dataset has 3 columns.")
} else {
  stop("Test Failed: The dataset does not have 3 columns.")
}

# Check that every respondent in the simulated survey data has a unique id
if (n_distinct(simulated_data$respondent_id) == nrow(simulated_data)) {
  message("Test Passed: All values in 'respondent_id' are unique.")
} else {
  stop("Test Failed: The 'respondent_id' column contains duplicate values.")
}

# Check if the 'state' column contains only vailid US state names
valid_us_states <- c(
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

if (all(simulated_data$state %in% valid_us_states)) {
  message("Test Passed: The 'state' column contains only valid U.S. state names.")
} else {
  stop("Test Failed: The 'state' column contains invalid state names.")
}

# Test that the race column only includes races listed in the CES survey
races <- c("white","black", "asian", "middle eastern", "native american",
           "hispanic", "pacific islander", "other", "chinese", "japanese",
           "asian", "south asian")

if (all(simulated_data$race %in% races)) {
  message("Test Passed: The 'races' column contains only the expected races.")
} else {
  stop("Test Failed: The 'race' column contains an unexpected race")
}

# Test tha
if (all(!is.na(simulated_data))) {
  message("Test Passed: The dataset contains no missing values.")
} else {
  stop("Test Failed: The dataset contains missing values.")
}

# Check that at least 2 distinct presidential candidates are present
if (n_distinct(simulated_data$presvote2020) >= 2) {
  message("Test Passed: The 'presvote2020' column contains at least two unique values.")
} else {
  stop("Test Failed: The 'presvote2020' column contains less than two unique values.")
}