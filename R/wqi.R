#' WQI
#'
#' Water quality index function
#' 
#' @param datin input \code{data.frame} with chemical and biological data
#' 
#' @details 
#' See \code{\link{sampdat}} for required input format
#' 
#' @export
#'
#' @return a \code{data.frame} same as \code{datin} but with new columns for \code{pChem}, \code{pHab}, \code{pChemHab}, \code{BiologicalCondtion}, \code{WaterChemistryCondition}, \code{HabitatCondition}, \code{OverallStressCondition}, and \code{StreamHealthIndex}
#' 
#' @importFrom magrittr "%>%"
#' 
#' @import randomForest
#' 
#' @examples
#' wqi(sampdat)
wqi <- function(datin){

  # probability of stress, chem, hab, and overall
  # model predicts probably of low stress
  datin$pChem<- predict(wqrfwp, newdata=datin, type="prob")[,2]
  datin$pHab<- predict(habrfwp, newdata=datin, type="prob")[,2]
  datin$pChemHab<- datin$pChem*datin$pHab
  
  # converse is estimated to get probability of stress
  datin$pChem <- 1 - datin$pChem
  datin$pHab <- 1 - datin$pHab
  datin$pChemHab <-  1 - datin$pChemHab
  
  out <- datin %>%
    dplyr::mutate(
      BiologicalCondition = ifelse(CSCI>=0.79 & ASCI>=60,"Healthy",
                                   ifelse(CSCI<0.79 & ASCI<60,"Impacted for BMI and algae",
                                          ifelse(CSCI<0.79 & ASCI>=60,"Impacted for BMI",
                                                 ifelse(CSCI>=0.79 & ASCI<60,"Impacted for algae", "XXXXX"
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
