library(DT)
library(shiny)
library(ggplot2)
library(data.table)

options(shiny.maxRequestSize = 30 * 1024^2)

draw_plot <- function(data_input, var_1, var_2, var_3) {
  if (var_1 != not_sel & !is.numeric(data_input[, (var_1)])) {
    data_input[, (var_1)] <- as.factor(data_input[, get(var_1)])
  }
  if (var_2 != not_sel & !is.numeric(data_input[, (var_2)])) {
    data_input[, (var_2)] <- as.factor(data_input[, get(var_2)])
  }
  if (var_3 != not_sel & !is.numeric(data_input[, (var_1)])) {
    data_input[, (var_3)] <- as.factor(data_input[, get(var_3)])
  }

  if (var_1 != not_sel) {
    showNotification(data_input[, (var_1)][[1]])
    # showNotification(class(data_input[, (var_1)][[1]]))
    # 1 variable case
    if (var_2 == not_sel & var_3 == not_sel) {
      # numeric case
      if (is.numeric(data_input[, (var_1)])) {
        # discrete
        if (is.discrete(data_input[, (var_1)])) {
          ggplot(data = data_input,
                 aes_string(x = var_1)) + geom_bar()
        }
          # continious
        else {
          ggplot(data = data_input,
                 aes_string(x = var_1)) + geom_histogram()
        }
      }
        # categorical case
      else {
        ggplot(data = data_input,
               aes_string(x = var_1)) + geom_bar()
      }

    }
      # 2 variable case
    else if (var_2 != not_sel & var_3 == not_sel) {
      showNotification(class(data_input[, (var_1)]))
      showNotification(class(data_input[, (var_2)]))

      # both numeric
      if (is.numeric(data_input[, (var_1)]) & is.numeric(data_input[, (var_2)])) {
        ggplot(data = data_input,
               aes_string(x = var_1, y = var_2)) + geom_line()
      }
        # 1 numeric - 1
      else if (is.numeric(data_input[, (var_1)]) & !is.numeric(data_input[, (var_2)])) {
        ggplot(data = data_input,
               aes_string(x = var_1, fill = var_2)) + geom_density()
      }
        # 1 numeric - 2
      else if (!is.numeric(data_input[, (var_1)]) & is.numeric(data_input[, (var_2)])) {
        ggplot(data = data_input,
               aes_string(x = var_2, fill = var_1)) + geom_density()
      }
        # both categorical
      else if (!is.numeric(data_input[, (var_1)]) & !is.numeric(data_input[, (var_2)])) {
        ggplot(data = data_input,
               aes_string(x = var_1, fill = var_2)) +
          geom_bar(position = "fill") +
          labs(y = "Proportion")
      }
    }
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
  })

  first_var_1 <- eventReactive(input$run_button_1, input$first_var_1)

  plot_1 <- eventReactive(input$run_button_1, {
    draw_plot(getData(), first_var_1(), not_sel, not_sel)
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


  plot_2 <- eventReactive(input$run_button_2, {
    draw_plot(getData(), second_var_1(), second_var_2(), not_sel)
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


  plot_3 <- eventReactive(input$run_button_3, {
    draw_plot(getData(), third_var_1(), third_var_2(), third_var_3())
  })

  output$plot_3 <- renderPlot(plot_3())

  output$bio_text_3 <- renderText({
    return("Lorem Ipsum Dolor molor kaputachya Amalfitano achqerd chinar du nanar sirun qnqush mer chinar")
  })


}