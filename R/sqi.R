#' SQI
#'
#' Stream quality index function
#' 
#' @param datin input \code{data.frame} with chemical, physical, and biological data
#' @param wq_mod_in input model object for predicting stressed state for water quality
#' @param hab_mod_in input model object for prediction stressed state for habitat
#' 
#' @details 
#' See \code{\link{sampdat}} for required input format.  \code{wq_mod_in} and \code{hab_mod_in} are both \code{\link[randomForest]{randomForest}} objects (\code{\link{wqrf}} and \code{\link{habrf}}, default) or \code{\link[mgcv]{gam}} objects (\code{\link{wqgam}} and \code{\link{habgam}}) included with the package. 
#' 
#' @export
#'
#' @return a \code{data.frame} same as \code{datin} but with new columns for \code{pChem}, \code{pHab}, \code{pChemHab}, \code{BiologicalCondtion}, \code{WaterChemistryCondition}, \code{HabitatCondition}, \code{OverallStressCondition}, and \code{StreamHealthIndex}
#' 
#' @importFrom magrittr "%>%"
#' 
#' @import mgcv randomForest
#' 
#' @examples
#' 
#' # using random forest models (default)
#' sqi(sampdat)
#' 
#' # using GAMs
#' sqi(sampdat, wq_mod_in = wqgam, hab_mod_in = habgam)
sqi <- function(datin, wq_mod_in = NULL, hab_mod_in = NULL){

  # rf models as default
  if(is.null(wq_mod_in))
    wq_mod_in <- wqrf
  if(is.null(hab_mod_in))
    hab_mod_in <- habrf
  
  ##
  # probability of stress, chem, hab, and overall
  # model predicts probably of low stress
  
  # gam predictions
  if(inherits(wq_mod_in, 'gam'))
    datin$pChem <- predict(wq_mod_in, newdata = datin, type = "response")
  if(inherits(hab_mod_in, 'gam'))
    datin$pHab <- predict(hab_mod_in, newdata = datin, type = "response")
  
  # randomforest predictions
  if(inherits(wq_mod_in, 'randomForest'))
    datin$pChem <- predict(wq_mod_in, newdata = datin, type = "prob")[,2]
  if(inherits(hab_mod_in, 'randomForest'))
    datin$pHab <- predict(hab_mod_in, newdata = datin, type = "prob")[,2]
  
  # combo stress estimate
  datin$pChemHab<- datin$pChem*datin$pHab
  
  # converse is estimated to get probability of stress
  datin$pChem <- 1 - datin$pChem
  datin$pHab <- 1 - datin$pHab
  datin$pChemHab <-  1 - datin$pChemHab
  
  out <- datin %>%
    dplyr::mutate(
      BiologicalCondition = ifelse(CSCI>=0.79 & ASCI>=60,"Healthy",
                                   ifelse(CSCI<0.79 & ASCI<60,"Impacted for CSCI and ASCI",
                                          ifelse(CSCI<0.79 & ASCI>=60,"Impacted for CSCI",
                                                 ifelse(CSCI>=0.79 & ASCI<60,"Impacted for ASCI", "XXXXX"
                                                 )))
      ),
      WaterChemistryCondition = cut(pChem,
                                    breaks = c(-Inf, 0.33, 0.67, Inf),
                                    labels = c('Low', 'Moderate', 'Severe'),
                                    right = F
      ),
      HabitatCondition = cut(pHab,
                             breaks = c(-Inf, 0.67, Inf),
                             labels = c('Low', 'Severe'),
                             right = F
      ),
      OverallStressCondition = cut(pChemHab,
                                   breaks = c(-Inf, 0.33, 0.67, Inf),
                                   labels = c('Low', 'Moderate', 'Severe'),
                                   right = F
      ),
      OverallStressCondition_detail = ifelse(pChemHab<0.33,"Low stress",
                                             ifelse(pChem>=0.33 & pHab>=0.33, "Stressed by chemistry and habitat degradation",
                                                    ifelse(pChem>=0.33 & pHab<0.33, "Stressed by chemistry degradation",
                                                           ifelse(pChem<0.33 & pHab>0.33, "Stressed by habitat degradation",
                                                                  ifelse(pChem<0.33 & pHab<0.33, "Stressed by low levels of chemistry or habitat degradation",
                                                                         "XXXXX"))))
      ),
      StreamHealthIndex = ifelse(BiologicalCondition=="Healthy" & OverallStressCondition=="Low","Healthy and unstressed",
                                 ifelse(BiologicalCondition=="Healthy" & OverallStressCondition!="Low","Healthy and resilient",
                                        ifelse(BiologicalCondition!="Healthy" & OverallStressCondition=="Low","Impacted by unknown stress",
                                               ifelse(BiologicalCondition!="Healthy" & OverallStressCondition!="Low","Impacted and stressed",
                                                      "XXXXX")))
      )
    ) %>% 
    dplyr::mutate_if(is.factor, as.character)
  
  return(out)
  
}