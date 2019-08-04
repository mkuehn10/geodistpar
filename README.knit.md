---
output: github_document
---

<!-- README.md is generated from README.Rmd. Please edit that file -->


# geodistpar

<!-- badges: start -->
<!-- badges: end -->

<!-- The goal of geodistpar is to ... -->

<!-- ## Installation -->

<!-- You can install the released version of geodistpar from [CRAN](https://CRAN.R-project.org) with: -->

<!-- ``` r -->
<!-- install.packages("geodistpar") -->
<!-- ``` -->

I developed some RcppParallel code to calculate large distance matrices quickly.  
I later discovered <https://github.com/hypertidy/geodist> and thought that a 
more aligned parallel version of that package could possibly have some use.

Also see: <https://github.com/hypertidy/geodist/issues/16>

``` r
# install.packages("devtools")
devtools::install_github("mkuehn10/geodistpar")
```
## Example


```r
library(geodistpar)
library(geodist)
library(microbenchmark)
library(ggplot2)

set.seed(10)
n <- 1000
x <- cbind (-10 + 20 * stats::runif (n), -10 + 20 * stats::runif (n))
y <- cbind (-10 + 20 * stats::runif (2 * n), -10 + 20 * stats::runif (2 * n))
colnames (x) <- colnames (y) <- c ("x", "y")

a <- geodist::geodist(x, y, measure = "haversine")
b <- geodistpar::geodistpar(x, y, measure = "haversine")

head(a[, 1:5])
#>           [,1]      [,2]      [,3]      [,4]      [,5]
#> [1,] 1225210.6 1788146.1  243415.8  941220.4 1184245.2
#> [2,] 1421649.3 1443725.5  693979.4 1436373.5 1146991.8
#> [3,]  990672.7  670982.9 1244972.4 1948938.0  381055.2
#> [4,]  459949.5 1496824.5  618702.2 1158123.6  549935.1
#> [5,] 1760882.6 1120247.4 1259339.6 2018837.7 1300613.0
#> [6,] 1399721.5  581798.6 1311268.4 2083635.0  828119.6
head(b[, 1:5])
#>           [,1]      [,2]      [,3]      [,4]      [,5]
#> [1,] 1225210.6 1788146.1  243415.8  941220.4 1184245.2
#> [2,] 1421649.3 1443725.5  693979.4 1436373.5 1146991.8
#> [3,]  990672.7  670982.9 1244972.4 1948938.0  381055.2
#> [4,]  459949.5 1496824.5  618702.2 1158123.6  549935.1
#> [5,] 1760882.6 1120247.4 1259339.6 2018837.7 1300613.0
#> [6,] 1399721.5  581798.6 1311268.4 2083635.0  828119.6
identical(a, b)
#> [1] TRUE

mb1 <- microbenchmark::microbenchmark(
  geodist = geodist::geodist(x, y, measure = "haversine"),
  geodistpar = geodistpar::geodistpar(x, y, measure = "haversine"),
  times = 25
)

mb1
#> Unit: milliseconds
#>        expr      min       lq      mean   median       uq      max neval
#>     geodist 325.3630 334.3536 341.89431 337.8233 343.5093 387.3065    25
#>  geodistpar  63.8012  74.3011  88.97711  86.6924  95.6527 141.7862    25
#>  cld
#>    b
#>   a
autoplot(mb1)
#> Coordinate system already present. Adding new coordinate system, which will replace the existing one.
```

<img src="man/figures/README-example-1.png" width="100%" />

```r

a <- geodist::geodist(x, y, measure = "vincenty")
b <- geodistpar::geodistpar(x, y, measure = "vincenty")

head(a[, 1:5])
#>           [,1]      [,2]      [,3]      [,4]      [,5]
#> [1,] 1225210.6 1788146.1  243415.8  941220.4 1184245.2
#> [2,] 1421649.3 1443725.5  693979.4 1436373.5 1146991.8
#> [3,]  990672.7  670982.9 1244972.4 1948938.0  381055.2
#> [4,]  459949.5 1496824.5  618702.2 1158123.6  549935.1
#> [5,] 1760882.6 1120247.4 1259339.6 2018837.7 1300613.0
#> [6,] 1399721.5  581798.6 1311268.4 2083635.0  828119.6
head(b[, 1:5])
#>           [,1]      [,2]      [,3]      [,4]      [,5]
#> [1,] 1225210.6 1788146.1  243415.8  941220.4 1184245.2
#> [2,] 1421649.3 1443725.5  693979.4 1436373.5 1146991.8
#> [3,]  990672.7  670982.9 1244972.4 1948938.0  381055.2
#> [4,]  459949.5 1496824.5  618702.2 1158123.6  549935.1
#> [5,] 1760882.6 1120247.4 1259339.6 2018837.7 1300613.0
#> [6,] 1399721.5  581798.6 1311268.4 2083635.0  828119.6
identical(a, b)
#> [1] TRUE

mb2 <- microbenchmark::microbenchmark(
  geodist = geodist::geodist(x, y, measure = "vincenty"),
  geodistpar = geodistpar::geodistpar(x, y, measure = "vincenty"),
  times = 25
)

mb2
#> Unit: milliseconds
#>        expr      min       lq     mean   median       uq      max neval
#>     geodist 410.6076 418.1190 429.3395 424.9092 429.1759 552.5144    25
#>  geodistpar  95.5457  97.0618 111.3339 104.8388 111.7687 234.4770    25
#>  cld
#>    b
#>   a
autoplot(mb2)
#> Coordinate system already present. Adding new coordinate system, which will replace the existing one.
```

<img src="man/figures/README-example-2.png" width="100%" />
