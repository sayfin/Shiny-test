library(shiny)

shinyUI(navbarPage("Oil Model", tabPanel("Historical data",
   sidebarLayout(
   sidebarPanel(
   sliderInput("bins", 
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),
    mainPanel(
    plotOutput("distPlot")
    )),
   fluidRow(
     column(3,
            #h3("Buttons"),
            actionButton("action", label = "Action"),
            br(),
            br(), 
            submitButton("Submit")),
     column(3,
            h3("Distribution fitting"),
            checkboxInput("checkbox", label = "Normal", value = TRUE)),
     column(3,
            #h2("Commodity"), 
            selectInput("selection", label = "Commodity", choices = c("Brent", "FX"), selected = "Brent"))
   )),
tabPanel("Stats"), navbarMenu("Simulation", tabPanel("Brent"), tabPanel("FX"))
))