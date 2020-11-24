library(shinydashboard)
library(shiny)
library(ggplot2)
library(leaflet)
library(dplyr)
library(plotly)
library(rgeos)
library(rgdal)
library(rsconnect)
library(polished)

# Define UI for application that draws a histogram
ui <- dashboardPage(
    dashboardHeader(title = "Dashboard"),
    sidebar = dashboardSidebar(collapsed = FALSE,
                               uiOutput('side_bar')),
    dashboardBody(
        tabBox(width = 12,
               tabPanel( title = "Number of students per state", status = "primary", solidHeader = TRUE,
                         collapsible = TRUE,
                         leafletOutput("map")),
               tabPanel(title = "Total number of students", status = "primary", solidHeader = TRUE,
                        collapsible = TRUE,
                        plotlyOutput("student_no"))
        ),
        fluidRow(
            box(width = 6, title = "Top 5 sources of students ", status = "primary", solidHeader = TRUE,
                collapsible = TRUE,
                uiOutput("selected_year"),
                plotlyOutput("student_sources")),
            box(width = 6, title = "Education sectors ", status = "primary", solidHeader = TRUE,
                collapsible = TRUE,
                plotlyOutput("student_sector"))
        ))
    
    
)
secure_ui(
    ui,
    sign_in_page_ui = sign_in_ui_default(
        color = "#000000",
        company_name = "Australia International Student Group",
        logo_top = tags$img(
            src = "images/education.png",
            alt = "Education Logo",
            style = "width: 125px; margin-top: 30px;"
        ),
        logo_bottom = tags$img(
            src = "images/knowlegde.png",
            alt = "Knowledge Logo",
            style = "width: 200px; margin-bottom: 15px; padding-top: 15px;"
        ),
        background_image = "images/students.jpg"
    ))