
library(tidyverse)
library(tidylog)
library(janitor)
library(shiny)
library(leaflet)
library(scales)
library(plotly)
library(knitr)
library(shinydashboard)

d <- read_csv("data/corona.csv")

d_last <- 
  d %>% 
  filter(date == max(date)) %>% 
  mutate(color = case_when(
    confirmed_num <= quantile(confirmed_num, .25) ~ "green",
    confirmed_num > quantile(confirmed_num, .25) & confirmed_num <= quantile(confirmed_num, .5)~ "yellow",
    confirmed_num > quantile(confirmed_num, .5) & confirmed_num <= quantile(confirmed_num, .75)~ "orange",
    TRUE ~"red"
  ))


# source('/cloud/project/helpers.R')
# 
# 
# # data files paths --------------------------------------------------------
# 
# 
# confirmed_url <-
#   "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
# deaths_url <-
#   "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
# recorved_url <-
#   "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"
# 
# 
# 
# # data cleaning -----------------------------------------------------------
# 
# l_urls <- list(confirmed_url, deaths_url, recorved_url)
# c_titles <- c("confirmed_num", "deaths_num", "recovered_num")
# 
# d <-
#   map2(l_urls, c_titles, clean_df5) %>%
#   reduce(left_join)
