#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source("predictingWords.R")

# Define server logic required to draw a histogram
shinyServer(function(input, output, clientData, session) {
  text <- reactive({
    as.character(tolower(trimws(input$text,"r")))
  })

  suggestions <- reactive(nextWords(text()))

  output$suggestion <- renderTable(t(suggestions()),colnames = FALSE)

})
