library(DT)
library(shiny)
library(ggplot2)
library(data.table)

options(shiny.maxRequestSize=30*1024^2)

get_graph_type <- function(graph_type) {
  if (graph_type == "point") {
    return(geom_point())
  }
  else if (graph_type == "bar") {
    return(geom_bar(stat = "identity"))
  }
  else if (graph_type == "hist") {
    return(geom_histogram(stat="count"))
  }
}


draw_plot <- function(data_input, num_var_1, num_var_2, fact_var, graph_type) {
  if (num_var_1 != not_sel & !is.numeric(num_var_1)) {
    data_input[, (num_var_1)] <- as.factor(data_input[, get(num_var_1)])
  }
  if (num_var_2 != not_sel & !is.numeric(num_var_2)) {
    data_input[, (num_var_2)] <- as.factor(data_input[, get(num_var_2)])
  }
  if (fact_var != not_sel & !is.numeric(fact_var)) {
    data_input[, (fact_var)] <- as.factor(data_input[, get(fact_var)])
  }

  if (num_var_1 != not_sel &
    num_var_2 != not_sel &
    fact_var != not_sel) {
    ggplot(data = data_input,
           aes_string(x = num_var_1, y = num_var_2, color = fact_var)) +
      get_graph_type(graph_type)
  }
  else if (num_var_1 != not_sel &
    num_var_2 != not_sel &
    fact_var == not_sel) {
    ggplot(data = data_input,
           aes_string(x = num_var_1, y = num_var_2)) +
      get_graph_type(graph_type)
  }
  else if (num_var_1 != not_sel &
    num_var_2 == not_sel &
    fact_var != not_sel) {
    ggplot(data = data_input,
           aes_string(x = fact_var, y = num_var_1)) +
      get_graph_type(graph_type)
  }
  else if (num_var_1 == not_sel &
    num_var_2 != not_sel &
    fact_var != not_sel) {
    ggplot(data = data_input,
           aes_string(x = fact_var, y = num_var_2)) +
      get_graph_type(graph_type)
  }
  else if (num_var_1 != not_sel &
    num_var_2 == not_sel &
    fact_var == not_sel) {
    ggplot(data = data_input,
           aes_string(x = num_var_1)) +
      get_graph_type(graph_type)
  }
  else if (num_var_1 == not_sel &
    num_var_2 != not_sel &
    fact_var == not_sel) {
    ggplot(data = data_input,
           aes_string(x = num_var_2)) +
      get_graph_type(graph_type)
  }
  else if (num_var_1 == not_sel &
    num_var_2 == not_sel &
    fact_var != not_sel) {
    ggplot(data = data_input,
           aes_string(x = fact_var)) +
      get_graph_type(graph_type)
  }
}

server <- function(input, output, session) {

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

  getData <- reactive({
    req(input$file1)
    getTable(input$file1)
  })

  ###################################################################
  ############## First plot's section, 1 variable case ##############
  ###################################################################

  observeEvent(getData(), {
    choices <- c(not_sel, names(getData()))
    updateSelectInput(session, "first_var_1", choices = choices)
    updateSelectInput(session, "first_var_2", choices = choices)
  })

  first_var_1 <- eventReactive(input$run_button_1, input$first_var_1)
  first_var_2 <- eventReactive(input$run_button_1, input$first_var_2)
  graph_type_1 <- eventReactive(input$run_button_1, input$graph_type_1)

  plot_1 <- eventReactive(input$run_button_1, {
    draw_plot(getData(), first_var_1(), first_var_2(), not_sel, graph_type_1())
  })

  output$plot_1 <- renderPlot(plot_1())

  output$bio_text_1 <- renderText({
    return("Lorem Ipsum Dolor molor kaputachya Amalfitano")
  })


  ###################################################################
  ############## Second plot's section, 2 variable case #############
  ###################################################################

  observeEvent(getData(), {
    choices <- c(not_sel, names(getData()))
    updateSelectInput(session, "second_var_1", choices = choices)
    updateSelectInput(session, "second_var_2", choices = choices)
  })

  second_var_1 <- eventReactive(input$run_button_2, input$second_var_1)
  second_var_2 <- eventReactive(input$run_button_2, input$second_var_2)
  graph_type_2 <- eventReactive(input$run_button_1, input$graph_type_2)


  plot_2 <- eventReactive(input$run_button_2, {
    draw_plot(getData(), second_var_1(), second_var_2(), not_sel, graph_type_2())
  })

  output$plot_2 <- renderPlot(plot_2())

  output$bio_text_2 <- renderText({
    return("Lorem Ipsum Dolor molor kaputachya Amalfitano achqerd chinar du nanar")
  })


  ###################################################################
  ############## Third plot's section, 3 variable case ##############
  ###################################################################

  observeEvent(getData(), {
    choices <- c(not_sel, names(getData()))
    updateSelectInput(session, "third_var_1", choices = choices)
    updateSelectInput(session, "third_var_2", choices = choices)
    updateSelectInput(session, "third_var_3", choices = choices)
  })

  third_var_1 <- eventReactive(input$run_button_3, input$third_var_1)
  third_var_2 <- eventReactive(input$run_button_3, input$third_var_2)
  third_var_3 <- eventReactive(input$run_button_3, input$third_var_3)
  graph_type_3 <- eventReactive(input$run_button_1, input$graph_type_3)


  plot_3 <- eventReactive(input$run_button_3, {
    draw_plot(getData(), third_var_1(), third_var_2(), third_var_3(), graph_type_3())
  })

  output$plot_3 <- renderPlot(plot_3())

  output$bio_text_3 <- renderText({
    return("Lorem Ipsum Dolor molor kaputachya Amalfitano achqerd chinar du nanar sirun qnqush mer chinar")
  })


}