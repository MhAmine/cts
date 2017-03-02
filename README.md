# cts

This is a simple web scraper that donwloads the "Congress Trump Score" dataset
available at [Tracking Congress In The Age Of Trump](https://projects.fivethirtyeight.com/congress-trump-score/),
maintained by [FiveThirtyEight](https://fivethirtyeight.com/).

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
