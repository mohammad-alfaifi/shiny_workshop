clean_df3 <- function(df, col_name){
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

clean_df4 <- function(file_path, col_name){
  
  read_csv(file_path) %>% 
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



clean_df5 <- function(file_path, col_name){
  
  df <- 
    read_csv(file_path) %>% 
    pivot_longer(-c(`Province/State`, `Country/Region`, Lat, Long), names_to = "date", values_to = "cases_num" ) %>% 
    clean_names() %>% 
    mutate(
      date = as.Date(date, format = "%m/%d/%y")
    ) 
  
  lookup_loc <- 
    df %>% 
    group_by(country_region) %>%
    slice(n()) %>% 
    select(country_region, long,lat)
  
  
  df %>% 
    group_by(date, country_region) %>% 
    summarise(cases_num = sum(cases_num)) %>% 
    ungroup() %>% 
    rename({{col_name}} := cases_num) %>% 
    left_join(lookup_loc) %>% 
    select(date, country_region, long, lat, everything())
    
}


