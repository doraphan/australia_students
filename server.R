# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    
    output$side_bar <- renderMenu({
        sliderInput("Year",
                    " ",
                    min = min(students$Year),
                    max = max(students$Year),
                    value = min(students$Year), sep = "", animate = animationOptions(interval = 1300, loop = FALSE))
        
    })
    
    output$map <- renderLeaflet({
        req(input$Year)
        #data file
        df_students <- students %>% group_by(Year, State) %>% summarise(Count = n())
        
        df_students_filter <- df_students %>% filter(Year == input$Year)
        
        df_students_filter$STE_NAME16 <- df_students_filter$State
        
        
        #shapefile
        merge.lga.profiles3<-sp::merge(states.shp, df_students_filter,
                                       by= "STE_NAME16", duplicateGeoms = TRUE)
        
        
        labels <- sprintf(
            "<strong>%s</strong><br/>%g Number of students</sup>",
            merge.lga.profiles3$STE_NAME16, merge.lga.profiles3$Count
        ) %>% lapply(htmltools::HTML)
        bins <- c(1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000, 5500, 6000, 6500, 7000, 7500,8000)
        pal <- colorBin("YlOrRd", domain = merge.lga.profiles3$Count, bins = bins)
        
        p1 <- leaflet(merge.lga.profiles3) %>%
            setView(lng = 133.7751, lat = -25.2744, zoom = 3.5)
        p1 %>% addPolygons(
            fillColor = ~pal(Count),
            weight = 2,
            opacity = 1,
            color = "white",
            dashArray = "3",
            fillOpacity = 0.7,
            highlight = highlightOptions(
                weight = 5,
                color = "#666",
                dashArray = "",
                fillOpacity = 0.7,
                bringToFront = TRUE),
            label = labels,
            labelOptions = labelOptions(
                style = list("font-weight" = "normal", padding = "3px 8px"),
                textsize = "15px",
                direction = "auto")) %>%
            addLegend(pal = pal, values = ~Count, opacity = 0.7, title = NULL,
                      position = "bottomright")    
    })
    
    output$student_no <- renderPlotly({
        req(input$Year)
        #dataset
        df_students_no <- students %>% group_by(Year) %>% summarise(Count = n())
        
        p2 <- ggplot(df_students_no, aes(x=Year, y = Count)) + geom_area(fill="lightblue") +
            scale_x_continuous(breaks = seq(2002,2020,1)) + labs(x = "Year", y = "Count") +
            geom_vline(xintercept = input$Year, linetype="dotted", color = "black", size=0.5) 
        
    })
    
    output$student_sources <- renderPlotly({
        req(input$Year)
        #dataset
        df_students_sources <- students %>% group_by(Year, Nationality) %>% summarise(Count = n())
        df_student_sources_filter <- df_students_sources %>% filter(Year == input$Year)
        
        df_student_sources_filter$Nationality <- df_student_sources_filter$Nationality %>% factor(levels = df_student_sources_filter$Nationality[order(df_student_sources_filter$Count)]) 
        
        df_student_sources_filter <- df_student_sources_filter %>% arrange(desc(Count)) %>% slice(1:5)
        
        p3 <- ggplot(df_student_sources_filter, aes(x = Nationality, y = Count)) + geom_bar(stat="identity", fill = "#036bfc") +
            labs(x = " ", y = "Count")
        
        p3 <- p3 + coord_flip()
        
        
    })
    
    output$student_sector <- renderPlotly({
        req(input$Year)
        #dataset
        df_student_sector <- students %>% group_by(Year, Sector) %>% summarise(Count = n())
        df_student_sector_filter <- df_student_sector %>% filter(Year == input$Year)
        
        p4 <- plot_ly(df_student_sector_filter , labels = ~Sector, values = ~Count, type = 'pie')
        p4 <- p4 %>% layout(title = '',
                            xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
                            yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE))
        
        
    })
    
    output$selected_year <- renderText({
        req(input$Year)
        paste("Year:", input$Year)
    })
    
    output$user_out <- renderPrint({
        session$userData$user()
    })
    
    observeEvent(input$sign_out, {
        sign_out_from_shiny()
        session$reload()
    })
    
}
polished::secure_server(server)