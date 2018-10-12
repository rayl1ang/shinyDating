library(readr)
library(tidyverse)
library(fmsb)
library(shiny)
library(shinydashboard)
library(DT)

SD_df <- read_csv('SD_clean.csv')

SD_df %>% 
  select(id, gender, age, race, age_o, race_o, career, sports:yoga, dec:shar,
         contains('_1')) -> onsite

SD_df %>% 
  select(id, gender, age, race, age_o, race_o, career, sports:yoga, dec:shar,
         contains('_2')) -> followup

SD_df %>% 
  select(id, gender, age, race, career, sports:yoga) %>% 
  distinct() %>% 
  group_by(gender) %>% 
  summarise_at(vars(sports:yoga), mean) %>% 
  gather(activities,average_score, -gender) %>% 
  mutate(activities = str_to_title(activities),
         fill_color = ifelse(gender == 'Female', '#F8766D', 'skyblue3'))  -> activities_df

SD_df %>% 
  filter(!is.na(career)) %>% 
  filter(!is.na(date)) %>% 
  mutate(fill_color = ifelse(gender == 'Female', 'tomato3', 'royalblue3'))-> career_df     

                