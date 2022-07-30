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

  # Needs to be changed
  sidebarLayout(
    sidebarPanel(
      selectInput("first_var_1", "Variable:",
                  c("Cylinders" = "cyl",
                    "Transmission" = "am",
                    "Gears" = "gear"))
    ),
    mainPanel(
      textOutput("input_var")
    )
  )
)

shinyApp(ui, server) 
