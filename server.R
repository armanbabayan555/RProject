library(DT)

server <- function(input, output) {

  ###################################################################
  ######## File Upload and returning the table to display it ########
  ###################################################################

  i <- reactive({ sliderInput$rows })
  output$contents <- DT::renderDataTable({
    req(input$file1)
    return(getTable(input$file1))
  }, options = list(
    paging = TRUE,
    pageLength = input$rows
  ))

  output$summary <- renderPrint({
    req(input$file1)
    str(getTable(input$file1))
  })

  ###################################################################
  ############## First plot's section, 1 variable case ##############
  ###################################################################

  output$input_var <- renderText({
    req(input$first_var_1)
    return(input$first_var_1)
  })


}