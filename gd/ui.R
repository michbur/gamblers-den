#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Tytuł"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       sliderInput("population_size",
                   "Rozmiar populacji:",
                   min = 2e6,
                   max = 120e6,
                   value = sample(seq(2e6, 120e6, 2e6), 1), 
                   step = 2e6),
       sliderInput("disease_rarity",
                   "Liczba chorych:",
                   min = 2e4,
                   max = 3e5,
                   value = sample(seq(2e4, 3e5, 2e4), 1), 
                   step = 2e4),
       selectInput("test_accuracy", "Dokładność testu:",
                   c("0.900" = 0.900,
                     "0.950" = 0.950,
                     "0.990" = 0.990,
                     "0.999" = 0.999),
                     selected = sample(c(0.900, 0.950, 0.990, 0.999), 1))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("distPlot"),
       tableOutput("decision_table"),
       textOutput("decision")
    )
  )
))
