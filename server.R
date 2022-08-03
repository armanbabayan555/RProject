library(DT)
library(shiny)
library(ggplot2)

data_test <- data.frame(
  name = c("A", "B", "C", "D", "E"),
  value = c(3, 12, 5, 18, 45),
  color = c("Green", "Blue", "Red", "Brown", "Orange")
)

server <- function(input, output) {

  ###################################################################
  ######## File Upload and returning the table to display it ########
  ###################################################################

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

  output$plot_1 <- renderPlot({
    req(input$first_var_1)
    req(input$first_var_2)
    var1 <- input$first_var_1
    var2 <- input$first_var_2
    p1 <- ggplot(data = data_test, mapping = aes(x = !!var1, y = !!var2)) + geom_bar(stat = "identity")
    return(p1)
  })

  output$bio_text_1 <- renderText({
    return("Lorem Ipsum Dolor molor kaputachya Amalfitano")
  })


  ###################################################################
  ############## Second plot's section, 2 variable case #############
  ###################################################################

  output$plot_2 <- renderPlot({
    req(input$second_var_1)
    req(input$second_var_2)
    var1 <- input$second_var_1
    var2 <- input$second_var_2
    p2 <- ggplot(data = data_test, mapping = aes(x = !!var1, y = !!var2)) + geom_bar(stat = "identity")
    return(p2)
  })

  output$bio_text_2 <- renderText({
    return("Lorem Ipsum Dolor molor kaputachya Amalfitano achqerd chinar du nanar")
  })


  ###################################################################
  ############## Third plot's section, 3 variable case ##############
  ###################################################################

  output$plot_3 <- renderPlot({
    req(input$third_var_1)
    req(input$third_var_2)
    req(input$third_var_3)
    var1 <- input$third_var_1
    var2 <- input$third_var_2
    var3 <- input$third_var_3
    p3 <- ggplot(data = data_test, mapping = aes(x = !!var1, y = !!var2, fill = !!var3)) + geom_bar(stat = "identity")
    return(p3)
  })

  output$bio_text_3 <- renderText({
    return("Lorem Ipsum Dolor molor kaputachya Amalfitano achqerd chinar du nanar sirun qnqush mer chinar")
  })


}