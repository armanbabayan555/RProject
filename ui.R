library(shiny)
library(shinythemes)

graph_types<-c("point", "bar", "hist")

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
      checkboxInput("header", "Header", TRUE),

      # Input: Select separator ----
      radioButtons("sep", "Separator",
                   choices = c(Comma = ",",
                               Semicolon = ";",
                               Tab = "\t"),
                   selected = ","),

      # Input: Select quotes ----
      radioButtons("quote", "Quote",
                   choices = c(None = "",
                               "Double Quote" = '"',
                               "Single Quote" = "'"),
                   selected = '"'),

      # Horizontal line ----
      tags$hr()
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Table", DT::dataTableOutput("contents")),
        tabPanel("Summary", verbatimTextOutput("summary"))
      )
    )
  ),

  ###################################################################
  ############## First plot's section, 1 variable case ##############
  ###################################################################

  fluidRow(
    column(3,
           wellPanel(
             selectInput("first_var_1", "Select Variable 1:",
                         choices = not_sel),
             selectInput("first_var_2", "Select Date:",
                         choices = not_sel),
             selectInput("graph_type_1", "Select Graph Type:",
                         choices = graph_types),
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
             selectInput("graph_type_2", "Select Graph Type:",
                         choices = graph_types),
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
             selectInput("graph_type_3", "Select Graph Type:",
                         choices = graph_types),
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
  )

)

shinyApp(ui, server)
