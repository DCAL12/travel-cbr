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


shinyServer(function(input, output, session) {
   
  # populate KnowledgeBase
  output$allCasesTable = renderDataTable(cases)
  
  # provide suggested inputs
  updateSelectizeInput(session, "HolidayTypeInput", 
                       choices = levels(cases$HolidayType), 
                       server = TRUE)
  updateSelectizeInput(session, "RegionInput", 
                       choices = levels(cases$Region), 
                       server = TRUE)
  updateSelectizeInput(session, "TransportationInput", 
                       choices = levels(cases$Transportation), 
                       server = TRUE)
  updateSelectizeInput(session, "AccommodationInput", 
                       choices = levels(cases$Accommodation), 
                       server = TRUE)
  updateSelectizeInput(session, "HotelInput", 
                       choices = levels(cases$Hotel), 
                       server = TRUE)
  
  # predict widget
  observeEvent(input$predictButton, {
      
      targetCase = data.frame(
          #JourneyCode = max(cases$JourneyCode) + 1,
          HolidayType = factor(input$HolidayTypeInput, levels(cases$HolidayType)),
          Price = input$PriceInput,
          NumberOfPersons = input$NumberOfPersonsInput,
          Region = factor(input$RegionInput, levels(cases$Region)),
          Transportation = factor(input$TransportationInput, levels(cases$Transportation)),
          Duration = input$DurationInput,
          Season = factor(input$SeasonInput, levels(cases$Season)),
          Accommodation = factor(input$AccommodationInput, levels(cases$Accommodation)),
          Hotel = factor(input$HotelInput, levels(cases$Hotel))
        )
      
      weights = c(
        input$HolidayTypeInputWeight,
        input$PriceWeight,
        input$NumberOfPersonsWeight,
        input$RegionWeight,
        input$TransportationWeight,
        input$DurationWeight,
        input$SeasonWeight,
        input$AccommodationWeight,
        input$HotelWeight
      )
      
      # ingnore NA columns
      populated = which(!is.na(targetCase))
      weights = weights[populated]
      targetCase = targetCase[, populated]
      
      similarityMatrix = na.omit(similarity(cases, targetCase, weights))
      
      if(length(similarityMatrix) < input$knnInput) {
        output$similarityHelp = renderText(c("Insufficient similar cases found. Ensure predictive variables ", 
                                             "are populated and weights are not set to zero, or reduce the ",
                                             "number of required neighbors."))
      }
      else {
        output$similarityHelp = renderText("")
        knnTable = kNearestNeighbors(similarityMatrix, cases, k = input$knnInput)
        output$similarCasesTable = renderTable(knnTable)
        output$predictedOutcome = renderText(interpolate.weightedVotes(
          knnTable$similarity, knnTable[, input$outcomeVariableSelector]))
      }
    }
  )
})
