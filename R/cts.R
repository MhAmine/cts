#' Convert info gathered from CTS html to table format.
#' 
#' @param info The information returned by the scraping at the
#' beginning of `get_cts`.
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
#' central loop of `get_votes`.
#' @param name Name of the congressperson whose information is
#' being gathered.
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
    cts_table()
  
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

#' Get the vote data for each congressperson
#' 
#' @param chamber Chamber from which to get the information. Can assume
#' one of 3 values: `house`, `senate`, or `both`.
#' @param progress Whether to show a progress bar when running.
#' 
#' @export
get_votes <- function(chamber = "both", progress = TRUE) {
  
  # Check 'chamber' argument
  if (!(chamber %in% c("house", "senate", "both"))) {
    message("Warning: invalid 'chamber' argument, defaulting to 'both'")
  }
  
  # Declare base URL
  url = "https://projects.fivethirtyeight.com/congress-trump-score/"
  
  # Read the html data from the Congress Trump Score website
  html <- xml2::read_html(url)
  
  # Get the full name of each congressperson
  names <- html %>%
    rvest::html_nodes(".name a .long") %>%
    rvest::html_text()
  
  # Get the url for each congressperson
  links <- html %>%
    rvest::html_nodes(".name a") %>%
    rvest::html_attr("href") %>%
    stringr::str_replace("/congress-trump-score/", "")
  
  # Pre-processing specific to each 'chamber' option
  if (chamber == "house") {
    links <- links[101:length(links)]
  } else if (chamber == "senate") {
    links <- links[1:100]
  } else {
    # Do nothing
  }
  
  # Loop over the urls and get each congressperson's votes
  data <- tibble::tibble()
  error_count <- 0
  pb <- utils::txtProgressBar(style = 3)
  for (i in 1:length(links)) {
    
    data <- tryCatch({
      html <- xml2::read_html(paste0(url, links[i]))
      
      tmp <- html %>%
        rvest::html_nodes(".num .value , .position , .measure a , .date a") %>%
        rvest::html_text() %>%
        votes_table(names[i])
      
      dplyr::bind_rows(data, tmp)
      },
      error = function(cond) {
        error_count <- error_count + 1
        return(data)
      },
      warning = function(cond) {
        error_count <- error_count + 1
        return(data)
      })
    
    if (progress) {utils::setTxtProgressBar(pb, i/length(links))}
  }
  
  # Convert some variables into decimals
  data <- data %>%
    dplyr::mutate(
      agreement_likelihood = as.numeric(stringr::str_replace_all(agreement_likelihood, "\\%", ""))/100,
      plus_minus = as.numeric(plus_minus)/100
    )
  
  # Warn about skipped urls
  if (error_count > 0) {
    message(paste0("Warning: couldn't reach ", error_count, " URLs; they were skipped"))
  }
  
  return(data)
}
