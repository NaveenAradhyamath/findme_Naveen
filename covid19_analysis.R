install.packages("tidyverse")
library(readr)
covid_df <- read_csv("covid19.csv")
dim(covid_df)
colnames(covid_df)
vector_cols <- covid_df
vector_cols
head(vector_cols)
glimpse(vector_cols)
library(tibble)
glimpse(vector_cols)
library(tidyverse)

covid_df_all_states <- covid_df %>% filter(Province_State == "All States") %>% select(-Province_State)
covid_df_all_states
covid_df_all_states_daily <- covid_df_all_states %>% select(Date, Country_Region, active, hospitalizedCurr, daily_tested, daily_positive,death)
covid_df_all_states_daily <- covid_df_all_states_daily %>% group_by(Country_Region) %>% summarise(tested = sum(daily_tested),
                                                                                                  positive = sum(daily_positive),
                                                                                                  active = sum(active),
                                                                                                  hospitalized = sum(hospitalizedCurr),
                                                                                                  death = sum(death)
                                                                                                  )
head(covid_df_all_states_daily)
covid_df_all_states_daily_sum <- covid_df_all_states_daily %>% arrange(-tested)
covid_df_all_states_daily_sum
covid_top_10 <- head(covid_df_all_states_daily_sum, 10)
covid_top_10
countries <- covid_top_10 %>% pull(Country_Region)
tested_cases <- covid_top_10 %>% pull(tested)
positive_cases <- covid_top_10 %>% pull(positive)
active_cases <- covid_top_10 %>% pull(active)
hospitalized_cases <- covid_top_10 %>% pull(hospitalized)
death_cases <- covid_top_10 %>% pull(death)
tested_cases 
reference_1 <- c(tested_cases, positive_cases, active_cases, hospitalized_cases,death_cases)
reference_1
names(reference_1) <- countries
reference_1
ratio_countywise <- positive_cases/tested_cases
ratio_countywise
positive_tested_top_3 <- c("united_kingdom" =0.113260617, "united_states" = 0.108618191, "turkey" = 0.080711720)
positive_tested_top_3
ratio_death <- death_cases/ positive_cases
death_top_3 <- c("Italy" = 6.89054070, "united_kingdom" = 5.17381927, "united_states" = 1.80329899)
death_top_3
united_kingdom <- c(0.11, 1473672, 166909, 0, 0)
united_states <- c(0.10, 17282363, 1877179, 0, 0)
turkey <- c(0.08, 2031192, 163941, 2980960, 0)
covid_mat <- rbind(united_kingdom, united_states, turkey)
colnames(covid_mat) <- c("Ratio", "tested", "positive", "active", "hospitalized")
covid_mat
question <- "Which countries have had the highest number of positive cases against the number of tests?"
answer <- c("Positive tested cases" = positive_tested_top_3)
list_1 <- list(covid_df, covid_df_all_states, covid_df_all_states_daily, covid_top_10)
list_2 <- list(covid_mat)
list_3 <- list(vector_cols,countries)
named_list <- list(list_1, list_2, list_3)
data_structure_list <- named_list
covid_analysis_list <- list(question, answer,data_structure_list)
covid_analysis_list[[2]]

