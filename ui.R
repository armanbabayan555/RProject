library(shiny)

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


# Create Shiny app ----
shinyApp(ui, server)