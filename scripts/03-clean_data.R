#### Preamble ####
# Purpose: Cleans the raw CCES data from Harvard Dataverse
# Author: Talia Fabregas
# Date: December 1, 2024
# Contact: talia.fabregas@mail.utoronto.ca
# License: MIT
# Pre-requisites: Run 02-download_data.R
# Any other information needed? No

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(arrow)

#### Clean data ####
raw_data <- read_parquet("data/01-raw_data/raw_cces22_common.parquet") 

# CC22_363 asks whether or not they intend to vote in 2022 midterms
# CC22_365_voted --> which senate candidate did you vote for 
# 367 is US house
# civic engagement and public trust options
reduced_raw_data <- raw_data |>
  select(TS_g2022, CC22_363, inputstate, commonweight, commonpostweight, vvweight, vvweight_post, tookpost, ccesmodule,
         birthyr, gender4, race, hispanic, educ, # demographics variables
         votereg, votereg_post, CC22_401, # voter registration and turnout
         pid7, presvote20post, CC22_365_voted, CC22_366_voted, CC22_367_voted, # ideology and vote choices
         CC22_300b_1, CC22_300b_2, CC22_300b_3, CC22_300b_4, CC22_300b_5, CC22_300b_6, CC22_300b_7, CC22_300b_8, # media
         CC22_310a, CC22_310b, CC22_310c, CC22_310d, # know which party controls US house and US senate
         CC22_423, CC22_424, # trust in federal govt and state govt
         CC22_431a, # contacted by a campaign
         newsint, CC22_302
         ) |>
  mutate(age = 2022 - birthyr)

reduced_raw_data$TS_g2022 <- as.numeric(reduced_raw_data$TS_g2022)

# use vvweight_post if looking at only respondents who matched to a voter validation record and answered both waves

# reduce to only include registered voters who reported voting for Trump or Biden in 2020
# identifying matched non-voters and unmatched voters who reported non-voting as non-voters
# this is the third option from the CES guide.
# voted_in_2022 means the person cast a ballot in the 2022 midterms. does not tell us anything
# about who they voted for in 2022 or which races they voted in
reduced_raw_data <- reduced_raw_data |>
  filter(presvote20post %in% c(1, 2)) |>
  mutate(voted_in_2022 = if_else(
    (TS_g2022 == 7) | 
      (is.na(TS_g2022) & CC22_401 == 5) | 
      (is.na(TS_g2022) & is.na(CC22_401)),
    0, 
    1
  )) |>
  mutate(voted_in_2022 = replace_na(voted_in_2022, 1)) |>
  mutate(presvote2020 = if_else(presvote20post==1, "Joe Biden", "Donald Trump"),
         state = case_when(
           inputstate == 1 ~ "Alabama",
           inputstate == 2 ~ "Alaska", 
           inputstate == 4 ~ "Arizona",
           inputstate == 5 ~ "Arkansas",
           inputstate == 6 ~ "California",
           inputstate == 8 ~ "Colorado",
           inputstate == 9 ~ "Connecticut",
           inputstate == 10 ~ "Delaware",
           inputstate == 11 ~ "District of Columbia",
           inputstate == 12 ~ "Florida",
           inputstate == 13 ~ "Georgia",
           inputstate == 15 ~ "Hawaii",
           inputstate == 16 ~ "Idaho",
           inputstate == 17 ~ "Illinois",
           inputstate == 18 ~ "Indiana",
           inputstate == 19 ~ "Iowa",
           inputstate == 20 ~ "Kansas",
           inputstate == 21 ~ "Kentucky",
           inputstate == 22 ~ "Louisiana",
           inputstate == 23 ~ "Maine",
           inputstate == 24 ~ "Maryland",
           inputstate == 25 ~ "Massachusetts",
           inputstate == 26 ~ "Michigan",
           inputstate == 27 ~ "Minnesota",
           inputstate == 28 ~ "Mississippi",
           inputstate == 29 ~ "Missouri",
           inputstate == 30 ~ "Montana",
           inputstate == 31 ~ "Nebraska",
           inputstate == 32 ~ "Nevada",
           inputstate == 33 ~ "New Hampshire",
           inputstate == 34 ~ "New Jersey",
           inputstate == 35 ~ "New Mexico",
           inputstate == 36 ~ "New York",
           inputstate == 37 ~ "North Carolina",
           inputstate == 38 ~ "North Dakota",
           inputstate == 39 ~ "Ohio",
           inputstate == 40 ~ "Oklahoma",
           inputstate == 41 ~ "Oregon",
           inputstate == 42 ~ "Pennsylvania",
           inputstate == 44 ~ "Rhode Island",
           inputstate == 45 ~ "South Carolina",
           inputstate == 46 ~ "South Dakota",
           inputstate == 47 ~ "Tennessee",
           inputstate == 48 ~ "Texas",
           inputstate == 49 ~ "Utah",
           inputstate == 50 ~ "Vermont",
           inputstate == 51 ~ "Virginia",
           inputstate == 53 ~ "Washington",
           inputstate == 54 ~ "West Virginia",
           inputstate == 55 ~ "Wisconsin",
           inputstate == 56 ~ "Wyoming"
         ),
      trustfed = case_when(
        CC22_423 == 1 ~ "A great deal",
        CC22_423 == 2 ~ "A fair amount",
        CC22_423 == 3 ~ "Not very much",
        CC22_423 == 8 ~ "None at all",
        TRUE ~ NA_character_
      ),
      truststate = case_when(
        CC22_424 == 1 ~ "A great deal",
        CC22_424 == 2 ~ "A fair amount",
        CC22_424 == 3 ~ "Not very much",
        CC22_424 == 8 ~ "None at all",
        TRUE ~ NA_character_
      ),
      age_bracket = case_when(age < 30 ~ "18-29",
                              age < 45 ~ "30-44",
                              age < 60 ~ "45-59",
                              age >= 60 ~ "60+"),
      gender = case_when(
        gender4 == 1 ~ "Male",
        gender4 == 2 ~ "Female",
        gender4 == 3 ~ "Non binary",
        gender4 == 4 ~ "Other"
      ),
      educ = case_when(
        educ == 1 ~ "No HS",
        educ == 2 ~ "High school graduate",
        educ == 3 ~ "Some college",
        educ == 4 ~ "2-year college degree",
        educ == 5 ~ "4-year college degree",
        educ == 6 ~ "Post-grad"
      ),
      contacted = if_else(CC22_431a == 1, "Yes", "No"),
      national_economy = case_when(
        CC22_302 == 1 ~ "Much better",
        CC22_302 == 2 ~ "Somewhat better",
        CC22_302 == 3 ~ "Same",
        CC22_302 == 4 ~ "Somewhat worse",
        CC22_302 == 5 ~ "Much worse",
        CC22_302 == 6 ~ "Not sure",
        is.na(CC22_302) ~ "Not sure"
        ),
      know_us_house = case_when(
        CC22_310a == 1 ~ "No",
        CC22_310a == 2 ~ "Yes",
        CC22_310a == 3 ~ "No",
        CC22_310a == 4 ~ "No",
        is.na(CC22_310a) ~ "No"
        
      ),
      know_us_senate = case_when(
        CC22_310b == 1 ~ "No",
        CC22_310b == 2 ~ "Yes",
        CC22_310b == 3 ~ "No",
        CC22_310b == 4 ~ "No",
        is.na(CC22_310b) ~ "No"
      ),
      political_interest = case_when(
        newsint == 1 ~ "Most of the time",
        newsint == 2 ~ "Some of the time",
        newsint == 3 ~ "Only now and then",
        newsint == 4 ~ "Hardly at all",
        newsint == 5 ~ "Don't know",
        is.na(newsint) ~ "No"
      ),
      race = case_when(
        race == 1 ~ "White",
        race == 2 ~ "Black",
        race == 3 ~ "Hispanic",
        race == 4 ~ "Asian",
        race == 5 ~ "Native American",
        race == 6 ~ "Middle Eastern",
        race == 7 ~ "Two or more races",
        race == 8 ~ "Other",
        is.na(race) ~ "Other"
      ),
      voted_for_trump = if_else(presvote2020 == "Donald Trump", 1, 0),
      know_power = if_else((know_us_house == "Yes" & know_us_senate == "Yes"), "Yes", "No")
      
  )

# what influenced whether or not someone voted in 2022?
# voted_in_2022, presvote20, age_bracket, educ, truststate, trustfed, know_house, know_senate, political_interest

clean_data <- reduced_raw_data |>
  select(voted_in_2022, presvote2020, voted_for_trump, gender, age_bracket, educ, truststate, trustfed, 
         know_us_house, know_us_senate, political_interest, commonweight, know_power, state, race)

clean_data$presvote2020 <- as.factor(clean_data$presvote2020)
clean_data$age_bracket <- as.factor(clean_data$age_bracket)
clean_data$educ <- as.factor(clean_data$educ)
clean_data$truststate <- as.factor(clean_data$truststate)
clean_data$trustfed <- as.factor(clean_data$trustfed)
clean_data$know_us_house <- as.factor(clean_data$know_us_house)
clean_data$know_us_senate <- as.factor(clean_data$know_us_senate)
clean_data$political_interest <- as.factor(clean_data$political_interest)
clean_data$know_power <- as.factor(clean_data$know_power)
clean_data$state <- as.factor(clean_data$state)
clean_data$race <- as.factor(clean_data$race)

clean_data <- na.omit(clean_data)
  
  


#### Save data ####
write_parquet(clean_data, "data/02-analysis_data/ces2022_analysis_data.parquet")
# Will want to save this as a parquet
# write_csv(cleaned_data, "outputs/data/analysis_data.csv")
