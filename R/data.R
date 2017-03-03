#' FiveThirtyEight's "Congress Trump Score" for every congressperson.
#'
#' @source \url{https://projects.fivethirtyeight.com/congress-trump-score/}, downloaded 2017-03-03
#' @format A tibble with columns:
#' \describe{
#'  \item{name}{Congressperson's full name}
#'  \item{chamber}{In which chamber the congressperson works ("House" or "Senate")}
#'  \item{party}{Congressperson's party abbreviation}
#'  \item{state,district}{State/district the congressperson respresents}
#'  \item{trump_score}{How often the member votes in line with Trump's position}
#'  \item{trump_margin}{Trump's share of the vote in the 2016 election minus Clinton's}
#'  \item{predicted_score}{How often the member is expected to support Trump based on Trump's 2016 margin}
#'  \item{trump_plus_minus}{Difference between a member's actual and predicted Trump-support scores}
#' }
"cts"

#' Information about every vote each congressperson has cast since 2017 (as reported by FiveThirtyEight).
#'
#' @source \url{https://projects.fivethirtyeight.com/congress-trump-score/}, downloaded 2017-03-03
#' @format A tibble with columns:
#' \describe{
#'  \item{name}{Congressperson's full name}
#'  \item{date}{Month and day in which the voting occured}
#'  \item{measure}{The title of the measure in question}
#'  \item{trump_position}{Trumps position towards the measure}
#'  \item{vote}{Vote cast by congressperson}
#'  \item{agreement_likelihood}{Probability the congressperson will agree with Trump's position}
#'  \item{plus_minus}{Calculated based on Trump's margin and likelihood of agreement for each vote}
#' }
"votes"
