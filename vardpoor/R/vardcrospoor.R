
vardcrospoor <- function(Y, 
                     Y_thres = NULL,
                     wght_thres = NULL, 
                     H, PSU, w_final, id,
                     Dom = NULL,
                     country, periods,
                     sort=NULL,
                     gender = NULL,
                     percentage=60,
                     order_quant=50,
                     alpha = 20,
                     dataset = NULL,
                     use.estVar = FALSE,
                     withperiod = TRUE,
                     netchanges = TRUE,
                     confidence = .95,
                     several.ok=FALSE,
                     type="linrmpg") {
  ### Checking

  all_choices <- c("linarpr","linarpt","lingpg","linpoormed",
                   "linrmpg","lingini","lingini2","linqsr")
  choices <- c("all_choices", all_choices)
  type <- tolower(type)
  type <- match.arg(type, choices, several.ok)
  if (any(type == "all_choices")) {type <- all_choices
                                   several.ok <- TRUE } 

  # check 'p'
  p <- percentage
  if(!is.numeric(p) || length(p) != 1 || p[1] < 0 || p[1] > 100) {
         stop("'percentage' must be a numeric value in [0,100]")
     } else p <- percentage[1]

  # check 'order_quant'

  oq <- order_quant
  if(!is.numeric(oq) || length(oq) != 1 || oq[1] < 0 || oq[1] > 100) {
         stop("'order_quant' must be a numeric value in [0,100]")
     } else order_quant <- order_quant[1]

  if(!is.numeric(alpha) || length(alpha) != 1 || alpha[1] < 0 || alpha[1] > 100) {
         stop("'alpha' must be a numeric value in [0,100]")  }

  if (!is.logical(withperiod)) stop("'withperiod' must be logical")
  if (!is.logical(netchanges)) stop("'netchanges' must be logical")
  if(!is.numeric(confidence) || length(confidence) != 1 || confidence[1] < 0 || confidence[1] > 1) {
          stop("'confidence' must be a numeric value in [0,1]")  }

  if(!is.null(dataset)) {
      dataset <- data.frame(dataset)
      aY <- Y
      if (min(Y %in% names(dataset))!=1) stop("'Y' does not exist in 'dataset'!")
      if (min(Y %in% names(dataset))==1) {
                                Y <- data.frame(dataset[, Y], check.names=FALSE)
                                names(Y) <- aY }
    
      if(!is.null(Y_thres)) {
          if (min(Y_thres %in% names(dataset))!=1) stop("'Y_thres' does not exist in 'dataset'!")
          if (min(Y_thres %in% names(dataset))==1) Y_thres <- dataset[, Y_thres] }    

      if(!is.null(wght_thres)) {
          if (min(wght_thres %in% names(dataset))!=1) stop("'wght_thres' does not exist in 'dataset'!")
          if (min(wght_thres %in% names(dataset))==1) wght_thres <- dataset[, wght_thres] }

      if(!is.null(H)) {
          aH <- H  
          if (min(H %in% names(dataset))!=1) stop("'H' does not exist in 'dataset'!")
          if (min(H %in% names(dataset))==1) {
                                H <- as.data.frame(dataset[, aH], stringsAsFactors=FALSE)
                                names(H) <- aH }}
      if(!is.null(id)) {
          aid <- id  
          if (min(id %in% names(dataset))!=1) stop("'id' does not exist in 'dataset'!")
          if (min(id %in% names(dataset))==1) {
                                id <- as.data.frame(dataset[, aid], stringsAsFactors=FALSE)
                                names(id) <- aid }}
     if(!is.null(PSU)) {
          aPSU <- PSU  
          if (min(PSU %in% names(dataset))!=1) stop("'PSU' does not exist in 'dataset'!")
          if (min(PSU %in% names(dataset))==1) {
                                PSU <- as.data.frame(dataset[, aPSU], stringsAsFactors=FALSE)
                                names(PSU) <- aPSU }}
      if(!is.null(w_final)) {
          aw_final <- w_final  
          if (min(w_final %in% names(dataset))!=1) stop("'w_final' does not exist in 'dataset'!")
          if (min(w_final %in% names(dataset))==1) {
                                w_final <- data.frame(dataset[, aw_final])
                                names(w_final) <- aw_final }}
      if(!is.null(country)) {
          country2 <- country
          if (min(country %in% names(dataset))!=1) stop("'country' does not exist in 'dataset'!")
          if (min(country %in% names(dataset))==1) country <- as.data.frame(dataset[, country], stringsAsFactors=FALSE)
          names(country) <- country2  }

      if(!is.null(periods)) {
          periods2 <- periods
          if (min(periods %in% names(dataset))!=1) stop("'periods' does not exist in 'dataset'!")
          if (min(periods %in% names(dataset))==1) periods <- data.frame(dataset[, periods], stringsAsFactors=FALSE)
          names(periods) <- periods2  }

      if(!is.null(gender)) {
          if (min(gender %in% names(dataset))!=1) stop("'gender' does not exist in 'dataset'!")
          if (min(gender %in% names(dataset))==1) gender <- dataset[, gender] }

      if(!is.null(sort)) {
          if (min(sort %in% names(dataset))!=1) stop("'sort' does not exist in 'dataset'!")
          if (min(sort %in% names(dataset))==1) sort <- dataset[, sort] }
     
      if (!is.null(Dom)) {
          Dom2 <- Dom
          if (min(Dom %in% names(dataset))!=1) stop("'Dom' does not exist in 'data'!")
          if (min(Dom %in% names(dataset))==1) {  
                  Dom <- as.data.frame(dataset[, Dom2], stringsAsFactors=FALSE) 
                  names(Dom) <- Dom2 }    }
      }

  # Y
  Y <- data.frame(Y)
  n <- nrow(Y)
  if (ncol(Y) != 1) stop("'Y' must have vector or 1 column data.frame, matrix, data.table")
  Y <- Y[,1]
  if (!is.numeric(Y)) stop("'Y' must be numerical")
  if (any(is.na(Y))) stop("'Y' has unknown values")

  # Y_thres
  if (!is.null(Y_thres)) {
       Y_thres <- data.frame(Y_thres)
       if (nrow(Y_thres) != n) stop("'Y_thres' must have the same length as 'Y'")
       if (ncol(Y_thres) != 1) stop("'Y_thres' must have vector or 1 column data.frame, matrix, data.table")
       Y_thres <- Y_thres[,1]
       if (!is.numeric(Y_thres)) stop("'Y_thres' must be numerical")
       if (any(is.na(Y_thres))) stop("'Y_thres' has unknown values") 
     } else Y_thres <- Y

  # wght_thres
  if (is.null(wght_thres)) wght_thres <- w_final
  wght_thres <- data.frame(wght_thres)
  if (nrow(wght_thres) != n) stop("'wght_thres' must have the same length as 'Y'")
  if (ncol(wght_thres) != 1) stop("'wght_thres' must have vector or 1 column data.frame, matrix, data.table")
  wght_thres <- wght_thres[,1]
  if (!is.numeric(wght_thres)) stop("'wght_thres' must be a numeric vector")
 
  # H
  H <- data.table(H)
  if (nrow(H) != n) stop("'H' length must be equal with 'Y' row count")
  if (ncol(H) != 1) stop("'H' must be 1 column data.frame, matrix, data.table")
  if (any(is.na(H))) stop("'H' has unknown values")
  if (is.null(names(H))) stop("'H' must be colnames")
  
  # id
  if (is.null(id)) id <- 1:n
  id <- data.table(id)
  if (any(is.na(id))) stop("'id' has unknown values")
  if (nrow(id) != n) stop("'id' length must be equal with 'Y' row count")
  if (ncol(id) != 1) stop("'id' must be 1 column data.frame, matrix, data.table")
  if (is.null(names(id))||(names(id)=="id")) setnames(id, names(id), "h_ID")

  # PSU
  PSU <- data.table(PSU)
  if (any(is.na(PSU))) stop("'PSU' has unknown values")
  if (nrow(PSU) != n) stop("'PSU' length must be equal with 'Y' row count")
  if (ncol(PSU) != 1) stop("'PSU' has more than 1 column")
  
  # gender
  if (!is.null(gender)) {
      if (!is.numeric(gender)) stop("'gender' must be numerical")
      if (length(gender) != n) stop("'gender' must be the same length as 'Y'")
      if (length(unique(gender)) != 2) stop("'gender' must be exactly two values")
      if (!all.equal(unique(gender),c(1, 2))) stop("'gender' must be value 1 for male, 2 for females")
   }

  # sort
  if (!is.null(sort) && !is.vector(sort) && !is.ordered(sort)) {
        stop("'sort' must be a vector or ordered factor") }
  if (!is.null(sort) && length(sort) != n) stop("'sort' must have the same length as 'Y'")     

  # w_final 
  w_final <- data.frame(w_final)
  if (nrow(w_final) != n) stop("'w_final' must be equal with 'Y' row count")
  if (ncol(w_final) != 1) stop("'w_final' must be vector or 1 column data.frame, matrix, data.table")
  w_final <- w_final[,1]
  if (!is.numeric(w_final)) stop("'w_final' must be numerical")
  if (any(is.na(w_final))) stop("'w_final' has unknown values") 
  
  # country
  country <- data.table(country)
  if (any(is.na(country))) stop("'country' has unknown values")
  if (nrow(country) != n) stop("'country' length must be equal with 'Y' row count")
  if (ncol(country) != 1) stop("'country' has more than 1 column")
  if (!is.character(country[[names(country)]])) stop("'country' must be character")

  # periods
  if (withperiod) {
        periods <- data.table(periods)
        if (any(is.na(periods))) stop("'periods' has unknown values")
        if (nrow(periods) != n) stop("'periods' length must be equal with 'Y' row count")
    } else if (!is.null(periods)) stop("'periods' must be NULL for those data")

  # Dom
  namesDom <- NULL
  if (!is.null(Dom)) {
    Dom <- data.table(Dom)
    if (any(duplicated(names(Dom)))) 
           stop("'Dom' are duplicate column names: ", 
                 paste(names(Dom)[duplicated(names(Dom))], collapse = ","))
    if (nrow(Dom) != n) stop("'Dom' and 'Y' must be equal row count")
    if (any(is.na(Dom))) stop("'Dom' has unknown values")
    if (is.null(names(Dom))) stop("'Dom' must be colnames")
    namesDom <- names(Dom)
    Dom <- Dom[, lapply(.SD, as.character), .SDcols = namesDom]
    Dom1 <- Dom[, lapply(namesDom, function(x) make.names(paste0(x, ".", get(x))))]
    Dom1 <- Dom1[, Dom := Reduce(function(x, y) paste(x, y, sep="__"), .SD)]
    Dom <- data.table(Dom, Dom1[, "Dom", with=FALSE])
  }
    
  
 # Calculation
 Dom1 <- n_h <- stratasf <- name1 <- nhcor <- n_h <- var <- NULL
 num <- count_respondents <- value <- estim <- pop_size <- NULL
 N <- se <- rse <- cv <- namesY <- H_sk <- NULL

 estim <- c()
 countryper <- copy(country)
 if (!is.null(periods)) countryper <- data.table(periods, countryper)
 idper <- data.table(id, countryper)

 size <- copy(countryper)
 if (!is.null(namesDom)) size <- data.table(size, Dom)
 names_size <- names(size)
 size <- data.table(size, sk=1, w_final)
 size <- size[, lapply(.SD, sum), keyby=names_size,
                 .SDcols=c("sk", "w_final")]
 setnames(size, c("sk", "w_final"), c("count_respondents", "pop_size"))
 
 Y1 <- data.table(idper)
 Y1$period_country <- do.call("paste", c(as.list(Y1[,names(countryper),with=FALSE]), sep="_"))
 Y1 <- data.table(Y1, H, PSU, w_final, check.names=TRUE)
 namesY1 <- names(Y1)
 setkeyv(Y1, names(idper))
 Dom <- Dom[, "Dom", with=FALSE]

 if ("linarpt" %in% type) {
       varpt <- linarpt(Y=Y, id=id, weight=w_final,
                        sort=sort, Dom=Dom,
                        period=countryper,
                        dataset=NULL, percentage=percentage,
                        order_quant=order_quant, var_name="lin_arpt")
       Y1 <- merge(Y1, varpt$lin, all.x=TRUE)
       esti <- data.table("ARPT", varpt$value, NA)
       setnames(esti, names(esti)[c(1, -1:0+ncol(esti))],
                                  c("type", "value", "value_eu"))
       estim <- rbind(estim, esti)
       varpt <- esti <- NULL
     }
 if ("linarpr" %in% type) {
       varpr <- linarpr(Y=Y, id=id, weight=w_final,
                        Y_thres=Y_thres,
                        wght_thres=wght_thres, sort=sort, 
                        Dom=Dom, period=countryper,
                        dataset=NULL, 
                        percentage=percentage,
                        order_quant=order_quant,
                        var_name="lin_arpr")
       Y1 <- merge(Y1, varpr$lin, all.x=TRUE)
       esti <- data.table("ARPR", varpr$value, NA)  
       setnames(esti, names(esti)[c(1, -1:0+ncol(esti))],
                                  c("type", "value", "value_eu"))
       estim <- rbind(estim, esti)
       varpr <- esti <- NULL
     }
  if (("lingpg" %in% type)&&(!is.null(gender))) {
        vgpg <- lingpg(Y=Y, gender=gender, id=id,
                       weight=w_final, sort=sort,
                       Dom=Dom, period=countryper,
                       dataset=NULL, var_name="lin_gpg")
        Y1 <- merge(Y1, vgpg$lin, all.x=TRUE)
        esti <- data.table("GPG", vgpg$value, NA)  
        setnames(esti, names(esti)[c(1, -1:0+ncol(esti))],
                                  c("type", "value", "value_eu"))
        estim <- rbind(estim, esti)
        vgpg <- esti <- NULL
     }
  if ("linpoormed" %in% type) {
        vporm <- linpoormed(Y=Y, id=id, weight=w_final,
                            sort=sort, Dom=Dom, period=countryper, 
                            dataset=NULL, percentage=percentage,
                            order_quant=order_quant, var_name="lin_poormed")
        Y1 <- merge(Y1, vporm$lin, all.x=TRUE)
        esti <- data.table("POORMED", vporm$value, NA)  
        setnames(esti, names(esti)[c(1, -1:0+ncol(esti))],
                                  c("type", "value", "value_eu"))
        estim <- rbind(estim, esti)
        vporm <- esti <- NULL
     }
  if ("linrmpg" %in% type) {
        vrmpg <- linrmpg(Y=Y, id=id, weight=w_final,
                         sort=sort, Dom=Dom, period=countryper,
                         dataset=NULL, percentage=percentage,
                         order_quant=order_quant, var_name="lin_rmpg")
        Y1 <- merge(Y1, vrmpg$lin, all.x=TRUE)
        esti <- data.table("RMPG", vrmpg$value, NA)  
        setnames(esti, names(esti)[c(1, -1:0+ncol(esti))],
                                  c("type", "value", "value_eu")) 
        estim <- rbind(estim, esti)
        vrmpg <- esti <- NULL
      }
  if ("linqsr" %in% type) {
       vqsr <- linqsr(Y=Y, id=id, weight=w_final, 
                      sort=sort, Dom=Dom, period=countryper,
                      dataset=NULL, alpha=alpha, var_name="lin_qsr") 
       Y1 <- merge(Y1, vqsr$lin, all.x=TRUE)
       esti <- data.table("QSR", vqsr$value)  
       setnames(esti, names(esti)[c(1, -1:0+ncol(esti))],
                                  c("type", "value", "value_eu"))
       estim <- rbind(estim, esti)
       vqsr <- esti <- NULL
    }
  if ("lingini" %in% type) {
       vgini <- lingini(Y=Y, id=id, weight=w_final,
                        sort=sort, Dom=Dom, period=countryper,
                        dataset=NULL, var_name="lin_gini")
       Y1 <- merge(Y1, vgini$lin, all.x=TRUE)
       esti <- data.table("GINI", vgini$value)  
       setnames(esti, names(esti)[c(1, -1:0+ncol(esti))],
                                  c("type", "value", "value_eu"))
       estim <- rbind(estim, esti)
       vgini <- vginia <- esti <- NULL
     }
  if ("lingini2" %in% type) {
       vgini2 <- lingini2(Y=Y, id=id, weight=w_final,
                          sort=sort, Dom=Dom, period=countryper,
                          dataset=NULL, var_name="lin_gini2")
       Y1 <- merge(Y1, vgini2$lin, all.x=TRUE)
       esti <- data.table("GINI2", vgini2$value)  
       setnames(esti, names(esti)[c(1, -1:0+ncol(esti))],
                                  c("type", "value", "value_eu"))
       estim <- rbind(estim, esti)
       vgini2 <- esti <- NULL
     }
  setnames(estim, "value", "estim")
  estim$period_country <- do.call("paste", c(as.list(estim[,names(countryper),with=FALSE]), sep="_"))
  nams <- names(countryper)
  if (!is.null(namesDom)) nams <- c(nams, "Dom")
  setkeyv(estim, nams)
  setkeyv(size, nams)
  estim <- merge(estim, size, all=TRUE)

  namesY2 <- names(Y1)[!(names(Y1) %in% namesY1)]
  namesY2w <- paste0(namesY2, "w")
  Y1[, (namesY2w):=lapply(namesY2, function(x) get(x)*w_final)]

  DT1 <- copy(Y1)
  names_id <- names(id)
  names_H <- names(H)
  names_PSU <- names(PSU)

  namesperc <- c("period_country", names(countryper))
  namesDT1k <- c(namesperc, names_H, names_PSU)

  size <- id <- Dom <- country <-  NULL
  H <- PSU <- nh <- nh_cor <- NULL
 
  #--------------------------------------------------------*
  # AGGREGATION AT PSU LEVEL ("ULTIMATE CLUSTER" APPROACH) |
  #--------------------------------------------------------*

  DT3 <- DT1[, lapply(.SD, sum, na.rm=TRUE), keyby=namesDT1k, .SDcols = namesY2w]
  setnames(DT3, namesY2w, namesY2)
  DT1 <- copy(DT3)
  DT1[, ("period_country"):=NULL]
  if (!netchanges) DT1 <- NULL

  # NUMBER OF PSUs PER STRATUM
  setkeyv(DT3, c(namesperc, names_H))
  DT3[, nh:=.N, by=c(namesperc, names_H)]

 #--------------------------------------------------------------------------*
 # MULTIVARIATE REGRESSION APPROACH USING STRATUM DUMMIES AS REGRESSORS AND |
 # STANDARD ERROR ESTIMATION 						      |
 #--------------------------------------------------------------------------*

 DT3H <- DT3[[names_H]]
 DT3H <- factor(DT3H)
 if (length(levels(DT3H))==1) { DT3[, stratasf:=1]
                                DT3H <- "stratasf"
                      }  else { DT3H <- data.table(model.matrix( ~ DT3H-1))
                                DT3 <- cbind(DT3, DT3H)
                                DT3H <- names(DT3H) }

 fits <-lapply(1:length(namesY2), function(i) {
         fitss <- lapply(split(DT3, DT3$period_country), function(DT3c) {
                  	y <- namesY2[i]
                        funkc <- as.formula(paste("cbind(", trim(toString(y)), ")~",
                                       paste(c(-1, DT3H), collapse= "+")))
                   	res1 <- lm(funkc, data=DT3c)

           	            if (use.estVar==TRUE) {res1 <- data.table(crossprod(res1$res))
                                } else res1 <- data.table(res1$res)
                        setnames(res1, names(res1)[1], "num") 
                        res1[, namesY:=y]

                        if (use.estVar==TRUE) {
                              setnames(res1, "num", "var") 
                              res1 <- data.table(res1[1], DT3c[1])
                          } else {
                              res1 <- data.table(res1, DT3c)
                              res1[, nhcor:=ifelse(nh==1,1, nh/(nh-1))]
                              res1[, var:=nhcor * num * num]
                            }
                        fits <- res1[, lapply(.SD, sum), 
                                       keyby=c(namesperc, "namesY"),
                                       .SDcols="var"]
                        return(fits)
                    })
            return(rbindlist(fitss))
        })
  res <- rbindlist(fits)    
  estim[, namesY:=paste0("lin_", tolower(type))]
  if (!is.null(namesDom)) estim[, namesY:=paste0(namesY, "__Dom.", Dom)]
  
  setkeyv(res, c(namesperc, "namesY"))
  setkeyv(estim, c(namesperc, "namesY"))
  res[, res:=1]
  estim[, estim:=1]
  res <- merge(estim, res, all=TRUE)

  estim <- DT3H <- NULL
  res[, Dom:="1"]
  res[, (c("namesY", "Dom", "period_country")):=NULL]

  res[, se:=sqrt(var)]
  res[, rse:=se/estim]
  res[, cv:=rse*100]
  
  res <- res[, c(names(countryper), namesDom, "type", "count_respondents",
                 "pop_size", "estim", "se", "var", "rse", "cv"), with=FALSE]

  list(data_net_changes=DT1, results=res)
}   


