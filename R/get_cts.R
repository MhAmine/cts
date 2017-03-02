#' Convert info gathered from html to table format.
#' 
#' @param info The information returned by the scraping at the
#' beginning of `get_cts`.
to_table <- function(info) {
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

#' Get the available "Congress Trump Score" information for each congressperson.
#' 
#' @param chamber Chamber from which to get the information. Can assume
#' one of 3 values: `house`, `senate`, or `both`.
#' 
#' @export
get_cts <- function(chamber = "both") {
  
  # Check 'chamber' argument
  if (!(chamber %in% c("house", "senate", "both"))) {
    message("Warning: invalid 'chamber' argument, defaulting to 'both'")
  }
  
  # Read the html data from the Congress Trump Score website
  html <- xml2::read_html("https://projects.fivethirtyeight.com/congress-trump-score/")
  
  # Get the numbers for each congressperson
  data <- html %>%
    rvest::html_nodes("td") %>%
    rvest::html_text() %>%
    to_table()
  
  # Get the full name of each congressperson
  names <- html %>%
    rvest::html_nodes(".name a .long") %>%
    rvest::html_text()
  
  # Join 'names' and 'data' into 'data'
  data <- tibble::tibble(name = names) %>%
    dplyr::bind_cols(data)
  
  # Pre-processing specific to each 'chamber' option
  if (chamber == "house") {
    data <- dplyr::filter(data, stringr::str_detect(state, "\\-"))
  }
  else if (chamber == "senate") {
    data <- dplyr::filter(data, !stringr::str_detect(state, "\\-"))
  }
  else {
    data <- dplyr::mutate(data, chamber = ifelse(stringr::str_detect(state, "\\-"), "House", "Senate"))
  }
  
  # Convert some variables into decimals
  data <- data %>%
    dplyr::mutate(
      trump_score = as.numeric(stringr::str_replace_all(trump_score, "\\%", ""))/100,
      trump_margin = as.numeric(trump_margin)/100,
      predicted_score = as.numeric(stringr::str_replace_all(predicted_score, "\\%", ""))/100,
      trump_plus_minus = as.numeric(trump_plus_minus)/100
    )
  
  # Post-processing specific to each 'chamber' option
  if (chamber == "house") {
    data <- tidyr::separate(data, state, c("state", "district"), "\\-")
  }
  else if (chamber == "senate") {
    # Do nothing
  }
  else {
    data <- suppressWarnings(tidyr::separate(data, state, c("state", "district"), "\\-"))
    data <- data[, c(1, 9, 2:8)]
  }
  
  return(data)
}
