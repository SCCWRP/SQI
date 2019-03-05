######
#' Sample data
#'
#' Sample data for calculating SQI scores
#'  
#' @format A \code{\link{data.frame}} of biological, chemical, and physical data, one row per sample
#' \describe{
#'   \item{\code{MasterID}}{chr} site id
#'   \item{\code{date}}{date} sample date
#'   \item{\code{CSCI}}{chr} CSCI score, 0 to ~ 1.4
#'   \item{\code{ASCI}}{chr} ASCI score, 0 to ~ 1.4
#'   \item{\code{IPI}}{num} IPI score, 0 to ~ 1.4
#'   \item{\code{PCT_SAFN}}{num} percent sands and fines
#'   \item{\code{H_AqHab}}{num} Shannon diversity of aquatic habitat, 0 to ~ 2.5
#'   \item{\code{H_SubNat}}{num} Shannon diversity of streambed substrate, 0 to ~ 2.5
#'   \item{\code{Ev_FlowHab}}{num} evenness of flow habitat, 0 to 1
#'   \item{\code{XCMG}}{num} riparian vegetation cover, %
#'   \item{\code{indexscore_cram}}{num} CRAM habitat score
#'   \item{\code{Cond}}{num} conductivity, uS/cm
#'   \item{\code{TN}}{num} total nitrogen, mg/L
#'   \item{\code{TP}}{num} total phosphorus, mg/L
#' }
#' 
#' @examples 
#' data(sampdat)
"sampdat"