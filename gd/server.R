#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)

detriple_number <- function(x) {
  x <- round(x, 0)
  triplets_start <- nchar(x) %% 3 + 1
  nchar_x <- nchar(x)
  
  if(nchar_x > 3) {
    first_part <- substring(x, 1, triplets_start - 1) 
    second_part <- substring(x, seq(triplets_start, nchar_x, 3), seq(triplets_start + 2, nchar_x, 3))
    vector_to_paste <- if(triplets_start == 1) {
      second_part
    } else {
      c(first_part, second_part)
    }
    paste0(vector_to_paste, collapse = " ")
  } else {
    as.character(x)
  }
}


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  
  get_inf_dat <- reactive({
    test_accuracy <- as.numeric(input[["test_accuracy"]])
    disease_rarity <- input[["disease_rarity"]]/input[["population_size"]]
    population_size <- input[["population_size"]]
    
    data.frame(infection = c(TRUE, TRUE, FALSE, FALSE),
                      diagnosis = c(TRUE, FALSE, TRUE, FALSE),
                      value = c(disease_rarity * population_size * test_accuracy,
                                disease_rarity * population_size * (1 - test_accuracy),
                                (1 - disease_rarity) * population_size * (1 - test_accuracy),
                                (1 - disease_rarity) * population_size * test_accuracy)) %>% 
      mutate(diagnosis = ifelse(diagnosis, "tak", "nie"),
             infection = ifelse(infection, "tak", "nie"))
  })
  
  output$distPlot <- renderPlot({
    
    dat <- get_inf_dat()
    
    ggplot(dat, aes(x = infection, 
                    y = log(value, 10),
                    #y = value,
                    fill = diagnosis, 
                    label = paste0(sapply(value, detriple_number), " badanych"))) +
      geom_col() +
      geom_text(position = position_stack(vjust=0.5), size = 5) +
      theme_bw(16) +
      scale_y_continuous("Liczba badanych (skala logarytmiczna)") +
      scale_x_discrete("Infekcja") +
      scale_fill_manual("Diagnoza", values = c("blue", "red"))
    
  })
  
  
  output$decision <- renderText({
    
    dat <- get_inf_dat()
    dat[dat[["infection"]] == "nie" & dat[["diagnosis"]] == "tak", "value"]/
      dat[dat[["infection"]] == "tak" & dat[["diagnosis"]] == "tak", "value"]
    
  })
  
  output$decision_table <- renderTable({
    
    get_inf_dat() %>% 
      #mutate(value = round(value, 0)) %>% 
      rename(Infekcja = infection,
             Diagnoza = diagnosis,
             `Liczba badanych` = value)
    
  }, digits = 0)
})
