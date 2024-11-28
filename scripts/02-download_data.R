#### Preamble ####
# Purpose: Download and save the raw data from Harvard Dataverse
# Author: Talia Fabregas
# Date: December 1,2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Load the tidyverse, janitor, haven, and arrow packages.
# - Ensure the 2022 CCES data has been downloaded from Harvard dataverse
# Any other information needed? No

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(haven)
library(arrow)

#### Download data ####
# Read in the data
raw_data <- read_dta("data/01-raw_data/CCES22_Common_OUTPUT_vv_topost.dta")
raw_data_csv <- read_csv("data/01-raw_data/CCES22_Common_OUTPUT_vv_topost.csv")

#### Save data ####
write_parquet(raw_data_csv, "data/01-raw_data/raw_cces22_common.parquet") 

         
