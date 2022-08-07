library(shiny)
library(shinythemes)

correlation_types <- c("pearson", "spearman")
not_sel <- "Not Selected"

ui <- fluidPage(
  theme = shinytheme("flatly"),

  ###################################################################
  ######## File Upload and returning the table to display it ########
  ###################################################################

  titlePanel("Uploading Files"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Choose CSV File",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv",
                           ".tsv")),
      tags$hr(),
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Summary", verbatimTextOutput("summary")),
        tabPanel("Table", DT::dataTableOutput("contents"))
      )
    )
  ),

  br(),
  br(),
  br(),

  ###################################################################
  ############## First plot's section, 1 variable case ##############
  ###################################################################

  fluidRow(
    column(3,
           wellPanel(
             selectInput("first_var_1", "Select Variable 1:",
                         choices = not_sel),
             numericInput("bin_width_1", "Select bar length (Optional, leave -1 for default): ",
                          min = 1, max = 100, value = -1),
             br(),
             actionButton("run_button_1", "Run", icon = icon("play"))
           )
    ),

    column(4,
           textOutput("bio_text_1")
    ),

    column(5,
           plotOutput("plot_1")
    )
  ),

  br(),
  br(),

  ###################################################################
  ############## Second plot's section, 2 variable case #############
  ###################################################################


  fluidRow(
    column(3,
           wellPanel(
             selectInput("second_var_1", "Select Variable 1:",
                         choices = not_sel),
             selectInput("second_var_2", "Select Variable 2:",
                         choices = not_sel),
             br(),
             actionButton("run_button_2", "Run", icon = icon("play"))
           )
    ),

    column(4,
           textOutput("bio_text_2")
    ),

    column(5,
           plotOutput("plot_2")
    )
  ),

  br(),
  br(),

  ###################################################################
  ############## Third plot's section, 3 variable case ##############
  ###################################################################

  fluidRow(
    column(3,
           wellPanel(
             selectInput("third_var_1", "Select Variable 1:",
                         choices = not_sel),
             selectInput("third_var_2", "Select Variable 2:",
                         choices = not_sel),
             selectInput("third_var_3", "Select Variable 3:",
                         choices = not_sel),
             selectInput("fill_type_3", "Select 3rd variable's usage:",
                         choices = c("color", "shape")),
             br(),
             actionButton("run_button_3", "Run", icon = icon("play"))
           )
    ),

    column(4,
           textOutput("bio_text_3")
    ),

    column(5,
           plotOutput("plot_3")
    )
  ),

  br(),
  br(),


  ###################################################################
  ####################### Correlation Heatmap #######################
  ###################################################################
  fluidRow(
    column(3, wellPanel(
      selectInput('correlation_type', 'Choose the Correlation Technique: ', choices = correlation_types)
    )),
    column(6,
           plotOutput("plot_4")
    ),
    column(3)
  )
)

shinyApp(ui, server)
