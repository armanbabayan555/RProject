data_test <- data.frame(
  name = c("A", "B", "C", "D", "E"),
  value = c(3, 12, 5, 18, 45),
  color = c("Green", "Blue", "Red", "Brown", "Orange")
)
ui <- fluidPage(


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
             varSelectInput("first_var_1", "Select Variable 1:",
                            data_test),
             varSelectInput("first_var_2", "Select Date:",
                            data_test),
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
             varSelectInput("second_var_1", "Select Variable 1:",
                            data_test),
             varSelectInput("second_var_2", "Select Vafiable 2:",
                            data_test),
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
             varSelectInput("third_var_1", "Select Variable 1:",
                            data_test),
             varSelectInput("third_var_2", "Select Vafiable 2:",
                            data_test),
             varSelectInput("third_var_3", "Select Vafiable 3:",
                            data_test),
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
