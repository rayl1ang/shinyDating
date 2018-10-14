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

SD_df %>% 
  ggplot(aes(go_out, date, color = gender)) + 
  geom_jitter() + 
  facet_grid(~gender) + 
  theme(plot.subtitle = element_text(vjust = 1), 
        plot.caption = element_text(vjust = 1), 
        axis.title = element_text(size = 13, colour = "gray28"), 
        axis.text = element_text(size = 11),
        plot.title = element_text(face = "bold", 
                                  colour = "gray28",
                                  hjust = 0.5)) +
  labs(x = "Outdoor Activities Frequency",                                                                                       
       y = "Dating Frequency", colour = "Gender",
       title = "Dating vs Outdoor Activity \n Frequencies by Gender") -> datingFreq_facet 

                