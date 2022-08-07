getTable <- function(file) {
  tryCatch(
  {
    data <- read.csv(file$datapath, stringsAsFactors = TRUE)
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

draw_plot <- function(data_input, var_1, var_2, var_3, bin_width_1 = -1, fill_type_3 = "color") {
  if (var_1 != not_sel) {
    # 1 variable case
    if (var_2 == not_sel & var_3 == not_sel) {
      if (bin_width_1 > 0) {
        # numeric
        if (is.numeric(data_input[, get(var_1)])) {
          ggplot(data = data_input,
                 aes_string(x = var_1)) + geom_histogram(bins = bin_width_1, fill = "blue")
        }
          # categorical
        else {
          ggplot(data = data_input,
                 aes_string(x = var_1)) + geom_bar(width = bin_width_1, fill = "blue")
        }

      }
      else {
        # numeric
        if (is.numeric(data_input[, get(var_1)])) {
          ggplot(data = data_input,
                 aes_string(x = var_1)) + geom_histogram(fill = "blue")
        }
          # categorical
        else {
          ggplot(data = data_input,
                 aes_string(x = var_1)) + geom_bar(fill = "blue")
        }
      }
    }
      # 2 variable case
    else if (var_2 != not_sel & var_3 == not_sel) {

      # both numeric
      if (is.numeric(data_input[, get(var_1)]) & is.numeric(data_input[, get(var_2)])) {
        ggplot(data = data_input,
               aes_string(x = var_1, y = var_2)) + geom_point()
      }
        # 1 numeric - 1
      else if (is.numeric(data_input[, get(var_1)]) & !is.numeric(data_input[, get(var_2)])) {
        ggplot(data = data_input,
               aes_string(x = var_1, y = var_2, fill = var_1)) + geom_violin()
      }
        # 1 numeric - 2
      else if (!is.numeric(data_input[, get(var_1)]) & is.numeric(data_input[, get(var_2)])) {
        ggplot(data = data_input,
               aes_string(x = var_1, y = var_2, fill = var_1)) + geom_boxplot()
      }
        # both categorical
      else if (!is.numeric(data_input[, get(var_1)]) & !is.numeric(data_input[, get(var_2)])) {
        ggplot(data = data_input,
               aes_string(x = var_1, fill = var_2)) +
          geom_bar(position = "fill") +
          labs(y = "Proportion")
      }
    }
      # 3 variable case
    else if (var_2 != not_sel & var_3 != not_sel) {
      if (fill_type_3 == "shape") {
        ggplot(data = data_input,
               aes_string(x = var_1, y = var_2, shape = var_3)) + geom_point()
      }
      else { ggplot(data = data_input,
                    aes_string(x = var_1, y = var_2, color = var_3)) + geom_point()
      }


    }
  }

}

