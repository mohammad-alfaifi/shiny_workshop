square_number <- function(x){
  x^2
}

y <- square_number(2)


toss <- c("head", "tail")

sample(toss, size = 1)


map_df(1:1000, function(x){
  sample(toss, size = 1) %>% 
    enframe()
}) %>% 
  count(value)



# libs --------------------------------------------------------------------

library(tidyverse)
library(tidylog)
library(janitor)



# dataset -----------------------------------------------------------------


confirmed_url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_confirmed_global.csv"
deaths_url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_deaths_global.csv"
recorved_url <- "https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_covid19_recovered_global.csv"



# reading data ------------------------------------------------------------
deaths <- read_csv(deaths_url)
confirmed <- read_csv(confirmed_url)
recovered <- read_csv(recorved_url)

d_deaths <- 
  deaths %>% 
  pivot_longer(-c(`Province/State`, `Country/Region`, Lat, Long), names_to = "date", values_to = "deaths_num" ) %>% 
  clean_names() %>% 
  mutate(
    date = as.Date(date, format = "%m/%d/%y")
  ) %>% 
  group_by(date, country_region) %>% 
  summarise(deaths_num = sum(deaths_num)) %>% 
  ungroup()


d_confirmed <- 
  confirmed %>% 
  pivot_longer(-c(`Province/State`, `Country/Region`, Lat, Long), names_to = "date", values_to = "confirmed_num" ) %>% 
  clean_names() %>% 
  mutate(
    date = as.Date(date, format = "%m/%d/%y")
  ) %>% 
  group_by(date, country_region) %>% 
  summarise(confirmed_num = sum(confirmed_num)) %>% 
  ungroup()


d_recovered <- 
  recovered %>% 
  pivot_longer(-c(`Province/State`, `Country/Region`, Lat, Long), names_to = "date", values_to = "recovered_num" ) %>% 
  clean_names() %>% 
  mutate(
    date = as.Date(date, format = "%m/%d/%y")
  ) %>% 
  group_by(date, country_region) %>% 
  summarise(recovered_num = sum(recovered_num)) %>% 
  ungroup()



# join --------------------------------------------------------------------

d <- 
  d_deaths %>% 
  left_join(d_confirmed) %>% 
  left_join(d_recovered)



# DRY ---------------------------------------------------------------------


clean_df <- function(df){
  df %>% 
    pivot_longer(-c(`Province/State`, `Country/Region`, Lat, Long), names_to = "date", values_to = "cases_num" ) %>% 
    clean_names() %>% 
    mutate(
      date = as.Date(date, format = "%m/%d/%y")
    ) %>% 
    group_by(date, country_region) %>% 
    summarise(cases_num = sum(cases_num)) %>% 
    ungroup()
}


d_confirmed <- 
  confirmed %>% 
  clean_df() %>% 
  rename(confirmed_num = cases_num)


d_deaths <- 
  deaths %>% 
  clean_df() %>% 
  rename(deaths_num = cases_num)


d_recovered <- 
  recovered %>% 
  clean_df() %>% 
  rename(recovered_num = cases_num)


d <- 
  d_deaths %>% 
  left_join(d_confirmed) %>% 
  left_join(d_recovered)



# DRY 2 -------------------------------------------------------------------


clean_df2 <- function(df, col_name){
  df %>% 
    pivot_longer(-c(`Province/State`, `Country/Region`, Lat, Long), names_to = "date", values_to = "cases_num" ) %>% 
    clean_names() %>% 
    mutate(
      date = as.Date(date, format = "%m/%d/%y")
    ) %>% 
    group_by(date, country_region) %>% 
    summarise(cases_num = sum(cases_num)) %>% 
    ungroup() %>% 
    rename({{col_name}} := cases_num)
}



d_deaths <-
  deaths %>% 
  clean_df2("deaths_num")


d_confirmed <- 
  confirmed %>% 
  clean_df2("confirmed_num")


d_deaths <- 
  deaths %>% 
  clean_df2("deaths_num")

d <- 
  d_deaths %>% 
  left_join(d_confirmed) %>% 
  left_join(d_recovered)



# DRY 3 -------------------------------------------------------------------
source('/cloud/project/helpers.R')

l_data <- list(deaths, confirmed, recovered )
c_titles <- c("deaths_num", "confirmed_num", "recovered_num")

dd <- 
  map2(l_data, c_titles, clean_df3) %>% 
  reduce(left_join)
