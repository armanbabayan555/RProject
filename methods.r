getTable <- function(file) {
  tryCatch(
  {
    df <- read.csv(file$datapath)
  },
    error = function(e) {
      stop(safeError(e))
    }
  )

  return(df)
}