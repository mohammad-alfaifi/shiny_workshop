#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(DT)

# d <- read_csv("data/processed.csv")
# # (present/past)-1
# d %>% 
#     arrange(date) %>% 
#     group_by(country_region) %>% 
#     filter(confirmed_num > 0) %>% 
#     mutate(growth_confirmed = confirmed_num/lag(confirmed_num) -1) %>% 
#     View()
# Define UI for application that draws a histogram
ui <- fluidPage(
  
  
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "data",
        label = "select data",
        choices = ls("package:datasets")
      ),
      selectInput(
        inputId = "plot_type",
        label = "select plot",
        choices = c("scatter", "line")
      ),
      uiOutput("x"),
      uiOutput("y"),
    ),
    mainPanel(
      tabsetPanel(
        tabPanel(
          "summary",
          verbatimTextOutput("summary")
        ),
        tabPanel(
          "plot",
          plotOutput("plot")
        ),
        tabPanel(
          "table",
          DTOutput("table")
        )
        
      )
      
    )
  )
  
  
  
  
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  data <- reactive({
    req(input$data)
    d <- get(input$data, "package:datasets")
    if(class(d) == "data.frame"){
      d
    }else{
      data.frame()
    }
  })
  
  output$summary <- renderText({
    data() %>%
      summary()
    
  })
  
  output$table <- renderDT({
    data()
  })
  
  
  
  # dynamic UI --------------------------------------------------------------
  
  output$x <- renderUI({
    selectInput(
      inputId = "x_col",
      label = "select x",
      choices = data() %>% colnames()
    )
  })
  
  output$y <- renderUI({
    selectInput(
      inputId = "y_col",
      label = "select y",
      choices = data() %>% colnames()
    )
  })
  
  output$plot <- renderPlot({
    req(input$x_col)
    
    
    p <-  
      data() %>%
      as_tibble() %>%
      ggplot(aes_string(x = input$x_col, y = input$y_col)) 
    
    if(input$plot_type == "line"){
      p + geom_line()
    }else{
      p + geom_point()
    }
    
  })
}

# Run the application
shinyApp(ui = ui, server = server)
