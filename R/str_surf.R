#' Plot probability surface for likelihood of stress 
#'
#' Plot probability surface for likelihood of habitat or water quality stress
#' 
#' @param xvar chr string of variable for x-axis
#' @param yvar chr string of variable for y-axis
#' @param mod chr string of habitat or water quality model to use, must be either \code{'hab_mod'} or \code{'wq_mod'}
#' @param mod_in chr string of model to use (GLM), appropriate for \code{mod}
#' @param title logical indicating if title is shown above plot
#' @param lenv numeric indicating resolution of probability surface
#' @param opt_vrs names list with optional constant values for variables not specified by \code{xvar} and \code{yvar}
#' @param low chr string for color on low end of palette
#' @param mid chr string for color at mid range of palette
#' @param high chr string for color at high end of palette
#' 
#' @details 
#' 
#' @details Plots a smooth surface of the likelihood of either habitat or water quality stress for selected ranges of two variables.  The remaining variables are held constant at average values for those in the calibration dataset unless manually set with user input.
#' 
#' @import mgcv
#' 
#' @importFrom dplyr filter group_by left_join mutate
#' @importFrom ggplot2 ggplot aes aes_string scale_fill_gradient2 theme_minimal theme guide_colourbar element_text guides ggtitle geom_point geom_tile scale_y_continuous scale_x_continuous theme_bw
#' @importFrom magrittr "%>%"
#' @importFrom tidyr gather nest spread unite unnest
#' @importFrom tibble deframe enframe
#' 
#' @export
#' 
#' @return A \code{\link[ggplot2]{ggplot}} object
#' 
#' @examples 
#' 
#' # water quality stress
#' opt_vrs <- list(
#'   TN = 2.22,
#'   TP = 0.156,
#'   Cond = 100
#' )
#' 
#' strs_surf(xvar = 'TN', yvar = 'TP', mod = 'wq_mod', mod_in = 'wqglm', opt_vrs = opt_vrs)
#' 
#' # habitat stress
#' opt_vrs <- list(
#'   blc = 100,
#'   ps = 100, 
#'   PCT_SAFN = 1
#' )
#' 
#' # hab
#' strs_surf(xvar = 'blc', yvar = 'PCT_SAFN', mod  = 'hab_mod', mod_in = 'habglm', opt_vrs = opt_vrs)
#' 
strs_surf <- function(xvar, yvar, mod = c('hab_mod', 'wq_mod'), mod_in = NULL, title = TRUE, lenv = 200, opt_vrs = NULL, low = "#2c7bb6", mid = "#ffffbf", high = "#d7191c"){
  
  # get mod arg
  mod <- match.arg(mod)
  
  # hab and wq vars
  hab_vrs <- c('blc', 'ps', 'PCT_SAFN')
  wq_vrs <- c('TN', 'TP', 'Cond')
  
  # rng and avgs for habitat/wq variables
  # averages from calibration data, all stations/dates
  rng_vrs <- tibble::tibble( 
    var = c(hab_vrs, wq_vrs),
    minv = c(25, 25, 0, 0, 0, 0),
    avev = c(76.1, 55.2, 0.616, 1.92, 0.232, 1615),
    maxv = c(100, 100, 1, 1.5, 0.3, 2000),
    modv = c('hab_mod', 'hab_mod', 'hab_mod', 'wq_mod', 'wq_mod', 'wq_mod')
  ) %>% 
    gather('rng', 'val', minv, avev, maxv)
  
  
  ## sanity checks
  # habitat
  if(mod == 'hab_mod'){
    
    # use rf mod is not provided
    if(is.null(mod_in))
      mod_in <- 'habglm'
    
    # chk xvar and yvar are in hab_vrs
    chk <- any(!c(xvar, yvar) %in% hab_vrs)
    if(chk)
      stop('xvar and yvar must be one of ', paste(hab_vrs, collapse = ', '))
    
    # check the optional variables if provided
    if(!is.null(opt_vrs)){
      
      # check if names are right
      chk <- any(!names(opt_vrs) %in% hab_vrs)
      if(chk)
        stop('Names in opt_vrs must match those in ', paste(hab_vrs, collapse = ', '))
      
    }
    
    # water quality    
  } else {
    
    # use rf mod is not provided
    if(is.null(mod_in))
      mod_in <- 'wqglm'
    
    # chk xvar and yvar are in wq_vrs
    chk <- any(!c(xvar, yvar) %in% wq_vrs)
    if(chk)
      stop('xvar and yvar must be one of ', paste(wq_vrs, collapse = ', '))
    
    # check the optional variables if provided
    if(!is.null(opt_vrs)){
      
      # check if names are right
      chk <- any(!names(opt_vrs) %in% wq_vrs)
      if(chk)
        stop('Names in opt_vrs must match those in ', paste(wq_vrs, collapse = ', '))
      
    }
    
  }
  
  # replace values in rng_vrs with those in opt_vrs
  # get probabilty from model for point
  if(!is.null(opt_vrs)){
    
    # opt_vrs in correct format
    opt_vrs <- opt_vrs %>% 
      enframe('var', 'avev') %>% 
      unnest() %>% 
      gather('rng', 'val', avev)
    
    # join rng_vars with opt_vrs and replace
    rng_vrs <- rng_vrs %>% 
      left_join(opt_vrs, by = c('var', 'rng')) %>% 
      mutate(val = ifelse(is.na(val.y), val.x, val.y)) %>% 
      dplyr::select(-val.x, -val.y)
    
    # data from opt_vrs to plot as single point
    # ceiling and floor by ranges in rng_vars
    toprd <- rng_vrs %>% 
      spread(rng, val) %>% 
      mutate(
        avev = pmin(avev, maxv),
        avev = pmax(avev, minv)
      ) %>% 
      filter(var %in% opt_vrs$var) %>% 
      dplyr::select(var, avev) %>% 
      spread(var, avev)
    
  }
  
  # subset correct model
  rng_vrs <- rng_vrs %>% 
    filter(modv %in% mod)
  
  # get xy vars to plot
  xy_vrs <- rng_vrs %>% 
    filter(var %in% c(xvar, yvar)) %>% 
    filter(!rng %in% 'avev') %>% 
    group_by(var) %>% 
    nest() %>% 
    mutate(
      val = purrr::map(data, ~ seq(min(.$val), max(.$val), length.out = lenv))
    ) %>% 
    dplyr::select(-data)
  
  # get constant vars
  cnt_vrs <- rng_vrs %>% 
    filter(!var %in% c(xvar, yvar)) %>% 
    filter(rng %in% 'avev') %>% 
    dplyr::select(-modv, -rng)
  
  # combined data to pred
  prd_vrs <- rbind(xy_vrs, cnt_vrs) %>% 
    deframe() %>% 
    expand.grid
  
  # modelled response surface
  if(inherits(get(mod_in), 'glm'))
    rsp <- paste0('predict(', mod_in, ', newdata = prd_vrs, type = "response")')
  rsp <- eval(parse(text = rsp))
  
  # combined predictation data and response
  toplo <- prd_vrs %>% 
    mutate(
      `Pr. stress` = rsp
    )
  
  # the plot
  p <- ggplot(toplo, aes_string(x = xvar, y = yvar)) +
    geom_tile(aes(fill = `Pr. stress`)) +
    # geom_contour(aes(z = `Pr. stress`), colour = 'black', linetype = 'dashed')  +
    scale_fill_gradient2(low = low, mid = mid, high = high, midpoint = 0.5) +
    theme_minimal(base_size = 14, base_family = 'serif') +
    theme(
      plot.title = element_text(size = 12), 
      legend.position = 'top'
    ) +
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    guides(fill = guide_colourbar(barheight = 0.5, barwidth = 10))
  
  # title
  if(title){
    
    titlvl <- cnt_vrs %>% 
      mutate(val = round(val, 1)) %>% 
      unite('con', var, val, sep = ' ') %>% 
      unlist %>% 
      paste(collapse = ', ') %>% 
      paste0('Constant values:\n\t ', .)
    
    # add actual 
    if(!is.null(opt_vrs)){
      
      selcvl <- opt_vrs %>% 
        filter(var %in% c(xvar, yvar)) %>% 
        mutate(val = round(val, 1)) %>% 
        unite('con', var, val, sep = ' ') %>% 
        dplyr::select(-rng) %>% 
        unlist %>% 
        paste(collapse = ', ') %>% 
        paste0('Selected values:\n\t ', .)
      
      titlvl <- paste0(selcvl, '\n\n', titlvl)
      
      # add point with predicted value
      p <- p + 
        geom_point(data = toprd, pch = 21, fill = 'white', size = 4)
      
    }
    
    # add title to plot
    p <- p + ggtitle(titlvl)
    
  }
  
  return(p)
  
}