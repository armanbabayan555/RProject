getTable <- function(file) {
  tryCatch(
  {
    data <- read.csv(file$datapath)
    for (j in seq_along(data)) {
      if (is.numeric(data[, j])) {
        na_s <- which(is.na(data[, j]))
        if (!is.null(na_s)) {
          for (i in na_s) {
            if (i == 1) {
              average <- mean(data[, j], na.rm = TRUE)
              if (is.integer(data[, j])) {
                data[i, j] <- as.integer(average)
              } else {
                data[i, j] <- average
              }
            }
            else {
              data[i, j] <- data[i - 1, j]
            }

          }

        }
      } else if (is.factor(data[, j])) {
        na_s <- which(is.na(data[, j]))
        if (!is.null(na_s)) {
          uniqv <- unique(data[, j])
          most_frequent <- uniqv[which.max(tabulate(match(data[, j], uniqv)))]
          frequency_table <- sort(table(data[, j]), decreasing = TRUE)
          for (i in na_s) {
            data[i, j] <- most_frequent
          }
        }
      }
    }

  },
    error = function(e) {
      stop(safeError(e))
    }
  )

  return(as.data.table(data))
}
