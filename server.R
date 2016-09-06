#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
ifelse(file.exists("data/.RData"), load("data/.RData"), source(file = "scripts/clean_data.R"))

shinyServer(function(input, output) {
   
  # list all cases
  output$casesTable = renderDataTable(cases)
})
