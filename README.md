
#### *Marcus W. Beck, <marcusb@sccwrp.org>, Raphael D. Mazor, <raphaelm@sccwrp.org>, Susanna Theroux, <susannat@sccwrp.org>, Kenneth C. Schiff, <kens@sccwrp.org>*

[![Travis-CI Build
Status](https://travis-ci.org/SCCWRP/SQI.svg?branch=master)](https://travis-ci.org/SCCWRP/SQI)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/SCCWRP/SQI?branch=master&svg=true)](https://ci.appveyor.com/project/SCCWRP/SQI)
[![DOI](https://zenodo.org/badge/154087271.svg)](https://zenodo.org/badge/latestdoi/154087271)

# Overview

This package provides functions to calculate a stream quality index
using stream data. The index requires biological, chemical, and physical
data.

# Installing the package

The development version of this package can be installed from Github:

``` r
install.packages('devtools')
library(devtools)
install_github('SCCWRP/SQI')
library(SQI)
```

# Usage

The core function is `sqi()`:

``` r
head(sampdat)
```

    ## # A tibble: 6 x 19
    ##   MasterID    yr  CSCI  ASCI   IPI PCT_SAFN H_AqHab H_SubNat Ev_FlowHab
    ##   <chr>    <dbl> <dbl> <dbl> <dbl>    <dbl>   <dbl>    <dbl>      <dbl>
    ## 1 402M000~  2015 0.729 0.969  1.07     0.81    1        0.96       0.77
    ## 2 402M000~  2015 0.945 1.14   1        0.77    0.73     0.97       0.78
    ## 3 402M000~  2015 0.283 1.17   0.95     0.77    0.78     1          0.15
    ## 4 402M000~  2016 0.703 0.932  0.98     0.95    0.85     1          0.18
    ## 5 402M000~  2016 0.315 0.886  0.93     0.96    0.96     0.93       0.3 
    ## 6 402S095~  2012 0.948 1.04   1        0.82    0.82     0.93       0.77
    ## # ... with 10 more variables: XCMG <dbl>, blc <dbl>, bs <dbl>, hy <dbl>,
    ## #   ps <dbl>, indexscore_cram <dbl>, Cond <dbl>, TN <dbl>, TP <dbl>,
    ## #   SiteSet <chr>

``` r
sqi(sampdat)
```

    ## # A tibble: 267 x 28
    ##    MasterID    yr  CSCI  ASCI   IPI PCT_SAFN H_AqHab H_SubNat Ev_FlowHab
    ##    <chr>    <dbl> <dbl> <dbl> <dbl>    <dbl>   <dbl>    <dbl>      <dbl>
    ##  1 402M000~  2015 0.729 0.969  1.07     0.81    1       0.96        0.77
    ##  2 402M000~  2015 0.945 1.14   1        0.77    0.73    0.97        0.78
    ##  3 402M000~  2015 0.283 1.17   0.95     0.77    0.78    1           0.15
    ##  4 402M000~  2016 0.703 0.932  0.98     0.95    0.85    1           0.18
    ##  5 402M000~  2016 0.315 0.886  0.93     0.96    0.96    0.93        0.3 
    ##  6 402S095~  2012 0.948 1.04   1        0.82    0.82    0.93        0.77
    ##  7 403BA01~  2010 0.943 0.953  0.71     0.5     0.59    0.77        0.88
    ##  8 403M015~  2016 0.431 0.463  0.41     0.04    0.52    0.290       1   
    ##  9 403M015~  2015 0.664 0.974  0.96     0.64    0.92    0.85        0.85
    ## 10 403M015~  2015 0.761 1.10   0.97     0.77    0.93    0.8         1   
    ## # ... with 257 more rows, and 19 more variables: XCMG <dbl>, blc <dbl>,
    ## #   bs <dbl>, hy <dbl>, ps <dbl>, indexscore_cram <dbl>, Cond <dbl>,
    ## #   TN <dbl>, TP <dbl>, SiteSet <chr>, pChem <dbl>, pHab <dbl>,
    ## #   pChemHab <dbl>, BiologicalCondition <chr>,
    ## #   WaterChemistryCondition <chr>, HabitatCondition <chr>,
    ## #   OverallStressCondition <chr>, OverallStressCondition_detail <chr>,
    ## #   StreamHealthIndex <chr>
