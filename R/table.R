#' Convert info gathered from CTS html to table format.
#' 
#' @param info The information returned by the scraping at the
#'   beginning of `get_cts`.
cts_table <- function(info) {
  aux <- length(info)
  table <- tibble::tibble()
  i <- 1
  
  while (i <= aux) {
    table <- dplyr::bind_rows(table, list(
      party = info[i + 1],
      state = info[i + 2],
      trump_score = info[i + 3],
      trump_margin = info[i + 4],
      predicted_score = info[i + 5],
      trump_plus_minus = info[i + 6]
    ))
    
    i = i + 7
  }
  
  return(table)
}

#' Convert info gathered from votes html to table format.
#' 
#' @param info The information returned by the scraping at the
#'   central loop of `get_votes`.
#' @param name Name of the congressperson whose information is
#'   being gathered.
votes_table <- function(info, name) {
  aux <- length(info)
  table <- tibble::tibble()
  i <- 1
  
  while (i <= aux) {
    table <- dplyr::bind_rows(table, list(
      name = name,
      date = info[i],
      measure = info[i + 1],
      trump_position = info[i + 2],
      vote = info[i + 3],
      agreement_likelihood = info[i + 4],
      plus_minus = info[i + 5]
    ))
    
    i = i + 6
  }
  
  return(table)
}