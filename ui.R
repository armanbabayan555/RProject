library(shiny)

# Define UI for data upload app ----
ui <- fluidPage(

  # App title ----
  titlePanel("Uploading Files"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      # Input: Select a file ----
      fileInput("file1", "Choose CSV File",
                multiple = FALSE,
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv",
                           ".tsv")),

      # Horizontal line ----
      tags$hr()
    ),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Data file ----
      DT::dataTableOutput("contents")

    )

  )
)


# Create Shiny app ----
shinyApp(ui, server)