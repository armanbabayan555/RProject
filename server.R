library(DT)
library(shiny)
library(ggplot2)
library(data.table)
library(dplyr)
library(reshape2)

options(shiny.maxRequestSize = 30 * 1024^2)


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
  bin_width_1 <- eventReactive(input$run_button_1, input$bin_width_1)

  plot_1 <- eventReactive(input$run_button_1, {
    draw_plot(getData(), first_var_1(), not_sel, not_sel, bin_width_1 = bin_width_1())
  })

  output$plot_1 <- renderPlot(plot_1())

  output$bio_text_1 <- renderText({
    return("This section is designed to plot a graph of 1 variable. It will plot a barplot, for which you can choose the bin width or simply leave it -1 to not specify anything")
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
    return("This section is designed to plot a graph of 2 variables. It will plot a line graph in case of 2 numeric variables, a bar plot for 2 categorical variables, and a density plot in all other cases")
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
  fill_type_3 <- eventReactive(input$run_button_3, input$fill_type_3)


  plot_3 <- eventReactive(input$run_button_3, {
    draw_plot(getData(), third_var_1(), third_var_2(), third_var_3(), fill_type_3 = fill_type_3())
  })

  output$plot_3 <- renderPlot(plot_3())

  output$bio_text_3 <- renderText({
    return("This section is designed to plot a graph of 3 variables. It can plot a correlation heatmap or a scatter plot, with 3rd variable used as color or shape, by your choice. At least 1 numeric variable should be selected for correlation heatmap")
  })


  ###################################################################
  ####################### Correlation Heatmap #######################
  ###################################################################

  get_lower_tri <- function(cormat) {
    cormat[upper.tri(cormat)] <- NA
    return(cormat)
  }

  get_upper_tri <- function(cormat) {
    cormat[lower.tri(cormat)] <- NA
    return(cormat)
  }

  reorder_cormat <- function(cormat) {
    dd <- as.dist((1 - cormat) / 2)
    hc <- hclust(dd)
    cormat <- cormat[hc$order, hc$order]
  }

  plot_4 <- eventReactive(input$file1, {
    num_dat <- select_if(getData(), is.numeric)
    cormat <- round(cor(num_dat), 2)
    cormat <- reorder_cormat(cormat)
    upper_tri <- get_upper_tri(cormat)
    melted_cormat <- melt(upper_tri, na.rm = TRUE)
    ggplot(data = melted_cormat, aes(x = Var1, y = Var2, fill = value)) +
      geom_tile(color = "white") +
      scale_fill_gradient2(low = "blue", high = "red", mid = "white",
                           midpoint = 0, limit = c(-1, 1), space = "Lab",
                           name = "Pearson\nCorrelation") +
      theme_minimal() +
      theme(axis.text.x = element_text(angle = 45, vjust = 1,
                                       size = 12, hjust = 1)) +
      coord_fixed() +
      geom_text(aes(Var2, Var1, label = value), color = "black", size = 4) +
      theme(
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        panel.grid.major = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        axis.ticks = element_blank(),
        legend.justification = c(1, 0),
        legend.position = c(0.6, 0.7),
        legend.direction = "horizontal") +
      guides(fill = guide_colorbar(barwidth = 7, barheight = 1,
                                   title.position = "top", title.hjust = 0.5))

  })

  output$plot_4 <- renderPlot(plot_4())


}