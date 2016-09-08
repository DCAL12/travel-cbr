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
shinyUI(navbarPage(
  title = "Travel CBR",
  tabPanel("Case Base", dataTableOutput("allCasesTable")),
  tabPanel("New Case",
    wellPanel(
      helpText(
        "Note: input known new case information",
        "to the left. Fields left blank will be",
        "ignored. Weight each attribute by",
        "relative importance in predicting the",
        "outcome variable. Select the desired",
        "outcome variable from the drop-down",
        "menu and choose an appropriate number of",
        "nearest neighbors (similar known cases)",
        "to best estimate the outcome. Once the",
        "parameters have been set, click predict to",
        "view similar cases and predicted outcome."
      )
    ),
    wellPanel(
      fluidRow(column(4, tags$h3("New Case:")),
               column(4, tags$h3("Weights:")),
               column(4, tags$h3("Predict:"))),
      fluidRow(
        column(3, selectizeInput("HolidayTypeInput",
                            label = "HolidayType", 
                            choices = NULL)),
        column(
          3,
          offset = 1,
          sliderInput(
            "HolidayTypeInputWeight",
            label = "",
            min = 0,
            max = 1,
            value = 1
          )
        ),
        column(
          4,
          offset = 1,
          selectInput(
            "outcomeVariableSelector",
            label = "Outcome Variable",
            choices = c(
              "HolidayType",
              "Price",
              "NumberOfPersons",
              "Region",
              "Transportation",
              "Duration",
              "Season",
              "Accommodation",
              "Hotel"
            ),
            selected = "Price"
          )
        )
      ),
      fluidRow(
        column(
          3,
          numericInput(
            "PriceInput",
            label = "Price",
            min = 0,
            step = 1,
            value = 0
          )
        ),
        column(
          3,
          offset = 1,
          sliderInput(
            "PriceWeight",
            label = "",
            min = 0,
            max = 1,
            value = 1
          )
        ),
        column(
          4,
          offset = 1,
          sliderInput(
            "knnInput",
            label = "Nearest Neighbors",
            min = 1,
            max = 100,
            value = 5
          )
        )
      ),
      fluidRow(
        column(
          3,
          numericInput(
            "NumberOfPersonsInput",
            label = "NumberOfPersons",
            min = 1,
            value = 1
          )
        ),
        column(
          3,
          offset = 1,
          sliderInput(
            "NumberOfPersonsWeight",
            label = "",
            min = 0,
            max = 1,
            value = 1
          )
        ),
        column(4, offset = 1,
               actionButton("predictButton",
                            label = "Predict"))
      ),
      fluidRow(column(
        3, selectizeInput("RegionInput",
                          label = "Region",
                          choices = NULL)
      ),
      column(
        3,
        offset = 1,
        sliderInput(
          "RegionWeight",
          label = "",
          min = 0,
          max = 1,
          value = 1
        )),
        column(4, offset = 1,
               tags$h3("Predicted Outcome:"),
               textOutput("predictedOutcome")
        )
      ),
      fluidRow(column(
        3, selectizeInput("TransportationInput",
                          label = "Transportation",
                          choices = NULL)
      ),
      column(
        3,
        offset = 1,
        sliderInput(
          "TransportationWeight",
          label = "",
          min = 0,
          max = 1,
          value = 1
        )
      )),
      fluidRow(column(
        3,
        numericInput(
          "DurationInput",
          label = "Duration",
          min = 1,
          value = 1
        )
      ),
      column(
        3,
        offset = 1,
        sliderInput(
          "DurationWeight",
          label = "",
          min = 0,
          max = 1,
          value = 1
        )
      )),
      fluidRow(column(
        3, selectInput(
          "SeasonInput",
          label = "Season",
          choices = c(
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"
          )
        )
      ),
      column(
        3,
        offset = 1,
        sliderInput(
          "SeasonWeight",
          label = "",
          min = 0,
          max = 1,
          value = 1
        )
      )),
      fluidRow(column(
        3, selectizeInput("AccommodationInput",
                          label = "Accommodation",
                          choices = NULL)
      ),
      column(
        3,
        offset = 1,
        sliderInput(
          "AccommodationWeight",
          label = "",
          min = 0,
          max = 1,
          value = 1
        )
      )),
      fluidRow(column(
        3, selectizeInput("HotelInput",
                          label = "Hotel",
                          choices = NULL)
      ),
      column(
        3,
        offset = 1,
        sliderInput(
          "HotelWeight",
          label = "",
          min = 0,
          max = 1,
          value = 1
        )
      ))
    ),
    
    wellPanel(
      tags$h2("Similar Cases"),
      textOutput("similarityHelp"),
      tableOutput("similarCasesTable")
    )
  )
))