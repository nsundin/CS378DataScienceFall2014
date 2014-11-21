## Copyright 2014 Nicholas Sundin
## Do not remove this header

library(shiny)
library(ggplot2)

shinyUI(basicPage(
  
  headerPanel("FARS Driver Anomaly Explorer"),
  
  mainPanel(
    sliderInput('minAnomaly', 'Minimum Anomaly', min=0.0, max=1.0,
                value=0.92, step=0.01, width=500),
    plotOutput('plotMap', height='auto'),
    dataTableOutput('table')
  )
))
