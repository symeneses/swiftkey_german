#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that
shinyUI(
  navbarPage("German SwiftKey",
             tabPanel("Swiftkey",
                      fluidRow(
                        column(4,
                               br(),
                               h2("Suggestions"),
                               tableOutput("suggestion"),
                               h2("Prediction"),
                               textOutput(outputId="prediction"),
                               br(),
                               textInput(inputId="text", label = "Write your text",value = "")
                        )
                      )
             ),
             navbarMenu("Help",
                        tabPanel("How does it work?", includeMarkdown("mySwiftKey.Rmd")),
                        tabPanel("About", includeMarkdown("README.md"))
             )
  )
)

