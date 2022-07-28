library(shiny)
library(ggplot2)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "mu",
                  label = "Mean for distribution:",
                  min = 1,max = 100, value = 50)),
    mainPanel(plotOutput("histogram"))
  ))
