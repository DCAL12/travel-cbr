#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Modules:
ifelse(file.exists("data/.RData"), load("data/.RData"), source(file = "scripts/clean_data.R"))
source("scripts/similarity.R")
source("scripts/predict.R")

shinyServer(function(input, output) {
   
  # list all cases
  output$allCasesTable = renderDataTable(cases)
  output$similarCasesTable = renderTable(head(cases))
})
