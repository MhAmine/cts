# cts

This is a simple web scraper that donwloads the "Congress Trump Score" dataset
available at [Tracking Congress In The Age Of Trump](https://projects.fivethirtyeight.com/congress-trump-score/),
maintained by [FiveThirtyEight](https://fivethirtyeight.com/).

### Usage

To download the data, simply run the `get_cts()` function.

```r
get_cts()
#> # A tibble: 531 × 9
#>                 name chamber party state district trump_score trump_margin predicted_score trump_plus_minus
#>                <chr>   <chr> <chr> <chr>    <chr>       <dbl>        <dbl>           <dbl>            <dbl>
#> 1       Cory Gardner  Senate     R    CO     <NA>       1.000       -0.049           0.515            0.485
#> 2        Dean Heller  Senate     R    NV     <NA>       1.000       -0.024           0.565            0.435
#> 3  Patrick J. Toomey  Senate     R    PA     <NA>       1.000        0.007           0.631            0.369
#> 4        Ron Johnson  Senate     R    WI     <NA>       1.000        0.008           0.632            0.368
#> 5        Marco Rubio  Senate     R    FL     <NA>       1.000        0.012           0.641            0.359
#> 6         Jeff Flake  Senate     R    AZ     <NA>       1.000        0.035           0.691            0.309
#> 7       Richard Burr  Senate     R    NC     <NA>       1.000        0.037           0.694            0.306
#> 8        Thom Tillis  Senate     R    NC     <NA>       1.000        0.037           0.694            0.306
#> 9   Susan M. Collins  Senate     R    ME     <NA>       0.857       -0.030           0.554            0.304
#> 10    Johnny Isakson  Senate     R    GA     <NA>       1.000        0.052           0.711            0.289
#> # ... with 521 more rows
```

If you want to restrict the scraping to only one chamber of Congress, use the `chamber` argument.

```r
get_cts(chamber = "house")
#> # A tibble: 431 × 8
#>                   name party state district trump_score trump_margin predicted_score trump_plus_minus
#>                  <chr> <chr> <chr>    <chr>       <dbl>        <dbl>           <dbl>            <dbl>
#> 1     David G. Valadao     R    CA       21       1.000       -0.155           0.169            0.831
#> 2     Barbara Comstock     R    VA       10       1.000       -0.100           0.311            0.689
#> 3       Carlos Curbelo     R    FL       26       0.846       -0.161           0.161            0.685
#> 4         Erik Paulsen     R    MN        3       1.000       -0.094           0.330            0.670
#> 5         Mike Coffman     R    CO        6       1.000       -0.089           0.346            0.654
#> 6  Ileana Ros-Lehtinen     R    FL       27       0.714       -0.197           0.098            0.616
#> 7      Darrell E. Issa     R    CA       49       1.000       -0.075           0.392            0.608
#> 8      Peter J. Roskam     R    IL        6       1.000       -0.070           0.409            0.591
#> 9       Stephen Knight     R    CA       25       1.000       -0.067           0.419            0.581
#> 10     Edward R. Royce     R    CA       39       0.929       -0.086           0.355            0.573
#> # ... with 421 more rows
```