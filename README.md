# cts

This is a simple web scraper that donwloads the "Congress Trump Score" dataset
available at [Tracking Congress In The Age Of Trump](https://projects.fivethirtyeight.com/congress-trump-score/),
maintained by [FiveThirtyEight](https://fivethirtyeight.com/).

You can donwload `cts` by runnning

```r
devtools::install_github("ctlente/cts")
```

### Usage

To download the data, run the `get_cts()` function.

```r
cts_both <- get_cts()
colnames(cts_both)
#> [1] "name"             "chamber"          "party"           
#> [4] "state"            "district"         "trump_score"     
#> [7] "trump_margin"     "predicted_score"  "trump_plus_minus"
```

If you want to restrict the scraping to only one chamber of Congress, simply use the `chamber` argument.

```r
cts_house <- get_cts(chamber = "house")
colnames(cts_house)
#> [1] "name"             "party"            "state"           
#> [4] "district"         "trump_score"      "trump_margin"    
#> [7] "predicted_score"  "trump_plus_minus"
```

You can also donwload the information about every vote cast by each congressperson with the `get_votes()` function.

```r
votes_both <- get_votes()
colnames(votes_both)
#> [1] "name"                 "date"                
#> [3] "measure"              "trump_position"      
#> [5] "vote"                 "agreement_likelihood"
#> [7] "plus_minus" 
```
