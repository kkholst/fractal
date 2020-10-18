<!-- README.md is generated from README.Rmd. Please edit that file -->



# Fractals in R

<!-- badges: start -->
  [![travis](https://travis-ci.com/kkholst/fractalr.svg?branch=master)](https://travis-ci.com/kkholst/fractalr)
  [![license](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
<!-- badges: end -->


## Installation


```r
remotes::install_github("kkholst/fractalr")
```

## Examples

To start the user interface:

```r
fraftalr::ui()
```
This wiil bring up a browser window with the shiny application.



```r
res <- fractalr:::.mandelbrot(cx=-0.7367, cy=0.1692, R=0.001, maxIter=500)
image(res, useRaster=TRUE, axes=FALSE)
```

<img src="man/figures/README-ex1-1.png" title="plot of chunk ex1" alt="plot of chunk ex1" width="50%" />


```r
res <- fractalr:::.julia(cx=0, cy=0, R=2, c=complex(1,-.79,0.15))
image(res, useRaster=TRUE, axes=FALSE, col=viridis::plasma(128, direction=-1))
```

<img src="man/figures/README-ex2-1.png" title="plot of chunk ex2" alt="plot of chunk ex2" width="50%" />
