server <- function(input, output) {
  output$histogram <- renderPlot({
    rn <- rnorm(n = 10000, mean = input$mu, sd = 5)
    ggplot() + geom_histogram(aes(x = rn), bins = 50)
  })
}

shinyApp(ui, server)