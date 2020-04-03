


source('/cloud/project/corona/global.R')


ui <-
    dashboardPage(
        
        dashboardHeader(title = "Corona dataset dashboard"),
        
        dashboardSidebar(
            sidebarMenu(
            menuItem("EDA",
                     tabName = "EDA")
        )),
        dashboardBody(
            tabItems(
            tabItem(tabName = "EDA",
                    fluidRow(
                        column(
                            2,
                            radioButtons(
                                inputId = "status",
                                label = "country by status",
                                choices = c("all", "very low", "low", "medium", "high")
                            ),
                        ),
                        column(10,
                               leafletOutput("map"), )
                    ),
                    
                    fluidRow(column(
                        10,
                        plotlyOutput("country_plot"),
                        offset = 2
                        
                    )),
                    fluidRow(
                        column(12,
                                 uiOutput("markdown")   
                                    ))
                    )
        ))
        
        
    )

server <- function(input, output) {
    df_last <- reactive({
        if (input$status != "all") {
            if (input$status == "very low") {
                g_color <- "green"
            } else if (input$status == "low") {
                g_color = "yellow"
            } else if (input$status == "medium") {
                g_color = "orange"
            } else{
                g_color = "red"
            }
            d_last %>%
                filter(color == g_color)
        } else{
            d_last
        }
    })
    output$map <- renderLeaflet({
        df_last() %>%
            leaflet() %>%
            addTiles() %>%
            addCircleMarkers(
                lng = ~ long,
                lat = ~ lat,
                popup = ~ paste(
                    "Country name: ",
                    "<b>",
                    country_region,
                    "</b> <br>",
                    "Confirmed cases: ",
                    "<b>",
                    scales::comma(confirmed_num),
                    " </b> <br>",
                    "Death cases: ",
                    "<b>",
                    scales::comma(deaths_num),
                    "</b>"
                    
                ),
                stroke = FALSE,
                fillOpacity = 0.5,
                layerId = ~ country_region,
                color = ~ color
                
            )
    })
    
    output$country_plot <- renderPlotly({
        country <- input$map_marker_click$id
        
        req(country)
        
        d %>%
            filter(country_region ==  input$map_marker_click$id) %>%
            pivot_longer(-c("date", "country_region", "long", "lat"), names_to = "case_type") %>%
            ggplot(aes(x = date, y = value, col = case_type)) +
            geom_line() +
            labs(title = country)
        ggplotly()
    })
    
    output$markdown <- renderUI({
        
        HTML(markdown::markdownToHTML(knit("../covid19.Rmd", quiet = TRUE), fragment.only = TRUE))
    })
}

# Run the application
shinyApp(ui = ui, server = server)
