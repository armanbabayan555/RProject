library(DT)

# Define server logic to read selected file ----
server <- function(input, output) {

  i <- reactive({ sliderInput$rows })

  output$contents <- DT::renderDataTable({

    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, head of that data file by default,
    # or all rows if selected, will be shown.

    req(input$file1)

    # when reading semicolon separated files,
    # having a comma separator causes `read.csv` to error
    tryCatch(
    {
      df <- read.csv(input$file1$datapath)
    },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      }
    )

    return(df)

  }, options = list(
    paging = TRUE,
    pageLength = input$rows
  )
  )
}