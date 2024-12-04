#### Preamble ####
# Purpose: Tests the cleaned and prepared data to.
# Author: Talia Fabregas
# Date: December 1, 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Install the tidyverse and testthat packages
# - Run 02-download_data.R and 03-clean_data.R
# Any other information needed? No


#### Workspace setup ####
library(tidyverse)
library(testthat)

analysis_data <- read_parquet("data/02-analysis_data/ces2022_analysis_data.parquet")


#### Test data ####
# Test that the cleaned dataset has no new rows
test_that("the cleaned dataset has no new rows", {
  expect_true(nrow(analysis_data) <= 60000)
})

# Test that the dataset has 15 columns
test_that("dataset has 15 columns", {
  expect_equal(ncol(analysis_data), 15)
})

# Test that the 'division' column is character type
test_that("'division' is character", {
  expect_type(analysis_data$division, "character")
})

# Test that the 'presvote2020' column is character type
test_that("'presvote2020' is character", {
  expect_type(analysis_data$presvote2020, "character")
})

# Test that the 'know_us_house' column is character type
test_that("'know_us_house' is character", {
  expect_type(analysis_data$know_us_house, "character")
})

# Test that there are no missing values in the dataset
test_that("no missing values in dataset", {
  expect_true(all(!is.na(analysis_data)))
})


# Test that 'presvote2020' contains only Donald Trump and Joe Biden
valid_candidates <- c("Donald Trump", "Joe Biden")
test_that("'presvote2020' contains only Donald Trump and Joe Biden", {
  expect_true(all(analysis_data$presvote2020 %in% valid_candidates))
})

# Test that there are no empty strings in 'division', 'party', or 'state' columns
test_that("no empty strings in 'presvote2020', 'gender', or 'trustfed' columns", {
  expect_false(any(analysis_data$presvote2020 == "" | analysis_data$gender == "" | analysis_data$trustfed == ""))
})

