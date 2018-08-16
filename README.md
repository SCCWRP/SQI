
#### *Marcus W. Beck, marcusb@sccwrp.org, Raphael D. Mazor, raphaelm@sccwrp.org*

[![Travis-CI Build Status](https://travis-ci.org/SCCWRP/WQI.svg?branch=master)](https://travis-ci.org/SCCWRP/WQI)
 [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/SCCWRP/WQI?branch=master&svg=true)](https://ci.appveyor.com/project/SCCWRP/WQI)
 
# Overview 

This package provides functions to calculate a water quality index using stream data.  The index requires biological and chemical data.

# Installing the package

The development version of this package can be installed from Github:


```r
install.packages('devtools')
library(devtools)
install_github('SCCWRP/WQI')
library(WQI)
```

# Usage

The core function is `wqi()`: 



```r
wqi(sampdat)
```

```
##    MasterID       date      CSCI ASCI PCT_SAFN H_AqHab H_SubNat Ev_FlowHab
## 1 911KCKCRx 2011-05-31 1.0828769   76       67    1.62     1.44       0.66
## 2 911S12262 2010-05-24 0.9524888   40       60    0.86     1.37       0.45
## 3  SMC04806 2013-07-11 0.7758977   40        7    1.08     1.33       0.99
## 4  SMC05109 2009-06-23 0.8124133   38       98    1.43     0.15       0.00
## 5    911LAP 2014-04-09 1.0469197   80       67    1.06     1.10       0.40
##   XCMG indexscore_cram Cond   TN2     TP pChem  pHab pChemHab
## 1  122              93  600 0.175 0.0345 0.707 0.425 0.300475
## 2   93              84  808 0.705 0.2690 0.001 0.159 0.000159
## 3  179              57 2437 0.258 0.0520 0.036 0.064 0.002304
## 4   87              73  196 1.300 0.3740 0.046 0.031 0.001426
## 5  139              71  871 0.128 0.0280 0.843 0.648 0.546264
##          BiologicalCondition WaterChemistryCondition HabitatCondition
## 1                    Healthy                     Low           Severe
## 2         Impacted for algae                  Severe           Severe
## 3 Impacted for BMI and algae                  Severe           Severe
## 4         Impacted for algae                  Severe           Severe
## 5                    Healthy                     Low           Severe
##   OverallStressCondition                 OverallStressCondition_detail
## 1                 Severe               Stressed by habitat degradation
## 2                 Severe Stressed by chemistry and habitat degradation
## 3                 Severe Stressed by chemistry and habitat degradation
## 4                 Severe Stressed by chemistry and habitat degradation
## 5               Moderate               Stressed by habitat degradation
##       StreamHealthIndex
## 1 Healthy and resilient
## 2 Impacted and stressed
## 3 Impacted and stressed
## 4 Impacted and stressed
## 5 Healthy and resilient
```

