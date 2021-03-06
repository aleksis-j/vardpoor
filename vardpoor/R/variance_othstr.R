
variance_othstr <- function(Y, H, H2, w_final, N_h = NULL, N_h2, period = NULL, dataset = NULL, checking = TRUE) {

  ### Checking
  if (checking) {   
    Y <- check_var(vars = Y, varn = "Y", dataset = dataset,
                   check.names = TRUE, isnumeric = TRUE)
    Ynrow <- nrow(Y)
    Yncol <- ncol(Y)
    
    H <- check_var(vars = H, varn = "H", dataset = dataset,
                   ncols = 1, isnumeric = FALSE, ischaracter = TRUE)
    
    H2 <- check_var(vars = H2, varn = "H2", dataset = dataset,
                    ncols = 1, Ynrow = Ynrow, isnumeric = FALSE,
                    ischaracter = TRUE, dif_name = names(H))
    
    w_final <- check_var(vars = w_final, varn = "w_final",
                         dataset = dataset, ncols = 1, Ynrow = Ynrow,
                         isnumeric = TRUE, isvector = TRUE)
    
    period <- check_var(vars = period, varn = "period",
                        dataset = dataset, Ynrow = Ynrow,
                        ischaracter = TRUE, mustbedefined = FALSE,
                        duplicatednames = TRUE)    
  }
  
  np <- sum(ncol(period))
  
  # N_h
  if (!is.null(N_h)) {
      N_h <- data.table(N_h)
      if (anyNA(N_h)) stop("'N_h' has missing values")
      if (ncol(N_h) != np + 2) stop(paste0("'N_h' should be ", np + 2, " columns"))
      if (!is.numeric(N_h[[ncol(N_h)]])) stop("The last column of 'N_h' should be numerical")
       
      nams <- c(names(period), names(H))
      if (all(nams %in% names(N_h))) {N_h[, (nams) := lapply(.SD, as.character), .SDcols = nams]
             } else stop(paste0("All strata titles of 'H'", ifelse(!is.null(period), "and periods titles of 'period'", ""), " have not in 'N_h'"))
   
      if (is.null(period)) {
             if (any(is.na(merge(unique(H), N_h, by = names(H), all.x = TRUE)))) stop("'N_h' is not defined for all strata")
             if (any(duplicated(N_h[, head(names(N_h), -1), with = FALSE]))) stop("Strata values for 'N_h' must be unique")
       } else { pH <- data.table(period, H)
                if (any(is.na(merge(unique(pH), N_h, by = names(pH), all.x = TRUE)))) stop("'N_h' is not defined for all strata and periods")
                if (any(duplicated(N_h[, head(names(N_h), -1), with = FALSE]))) stop("Strata values for 'N_h' must be unique in all periods")
                pH <- NULL
              }
      setkeyv(N_h, names(N_h)[c(1 : (1 + np))])
  } else {
    Nh <- data.table(H, w_final)
    if (!is.null(period)) Nh <- data.table(period, Nh)
    N_h <- Nh[, .(N_h = sum(w_final, na.rm = TRUE)), keyby = c(names(Nh)[1 : (1 + np)])]
  }
  Nh1 <- names(N_h)[ncol(N_h)]


  # N_h2
  if (!is.null(N_h2)) {
      N_h2 <- data.table(N_h2)
      if (anyNA(N_h2)) stop("'N_h2' has missing values") 
      if (ncol(N_h2) != np + 2) stop(paste0("'N_h2' should be ", np + 2, " columns"))
      if (!is.numeric(N_h2[[ncol(N_h2)]])) stop("The last column of 'N_h2' should be numerical")

      nams2 <- c(names(period), names(H2))
      if (all(nams2 %in% names(N_h2))) {N_h2[, (nams2) := lapply(.SD, as.character), .SDcols = nams2]
             } else stop(paste0("All strata titles of 'H2'", ifelse(!is.null(period), "and periods titles of 'period'", ""), " have not in 'N_h2'"))
   
      if (is.null(period)) {
             if (names(H2) != names(N_h2)[1]) stop("Strata titles for 'H2' and 'N_h2' is not equal")
             if (any(is.na(merge(unique(H2), N_h2, by = names(H2), all.x = TRUE)))) stop("'N_h2' is not defined for all stratas")
       } else { pH2 <- data.table(period, H2)
                if (any(names(pH2) != names(N_h2)[c(1 : (1 + np))])) stop("Strata titles for 'period' with 'H2' and 'N_h2' is not equal")
                if (any(is.na(merge(unique(pH2), N_h2, by = names(pH2), all.x = TRUE)))) stop("'N_h2' is not defined for all stratas and periods")
                } 
    setkeyv(N_h2, names(N_h2)[c(1 : (1 + np))])
  } else stop ("N_h2 is not defined!")
  Nh2 <- names(N_h2)[ncol(N_h2)]

  ### Calculation
  
  # z_hi
  f_h1 <- .SD <- .N <- NULL
  Ys <- copy(Y)
  Ys[, paste0(names(Y),"_sa") := lapply(Y, function(x) w_final * x^2)]
  Ys[, paste0(names(Y),"_sb") := lapply(Y, function(x) x * w_final)]
  Ys[, paste0(names(Y),"_sc") := lapply(Y, function(x) x ^ 2)]
  Ys[, paste0(names(Y),"_sd") := Y]

  Ys <- data.table(H, H2, Ys)
  if (!is.null(period)) Ys <- data.table(period, Ys)

  # n_h1
  n_h1 <- data.table(H)
  if (!is.null(period))   n_h1 <- data.table(period, n_h1)
  n_h1 <- n_h1[, .(n_h1 = .N), keyby = c(names(n_h1))]

  F_h1 <- merge(N_h, n_h1, keyby = c(names(N_h)[1 : (1 + np)]))
  F_h1[, f_h1 := n_h1 / get(Nh1)]

  if (nrow(F_h1[n_h1 == 1 & f_h1 != 1]) > 0) {
    print("There are strata, where n_h1 == 1 and f_h1 <> 1")
    print("Not possible to estimate the variance in these strata!")
    print("At these strata estimation of variance was not calculated")
    nh1 <- F_h1[n_h1 == 1 & f_h1 != 1]
    print(nh1)
  }

  # n_h2
  n_h2 <- data.table(H2)
  if (!is.null(period)) n_h2 <- data.table(period, n_h2)
  nn_h2 <- names(n_h2)
  n_h2 <- n_h2[, .(n_h2 = .N), keyby = nn_h2]

  F_h2 <- merge(N_h2, n_h2, keyby = nn_h2)
  F_h2[, f_h2 := n_h2 / get(Nh2)]

  if (nrow(F_h2[n_h2 == 1 & f_h2 != 1]) > 0) {
    print("There are strata, where n_h2 == 1 and f_h2 <> 1")
    print("Not possible to estimate the variance in these strata!")
    print("At these strata estimation of variance was not calculated")
    nh2 <- F_h2[n_h2 == 1 & f_h2 != 1]
    print(nh2)
  }
  
  if (nrow(F_h2[f_h2 > 1]) > 0) {    
      print("There are strata, where f_h2 > 1")
      print("At these strata estimation of variance will be 0")
      print(F_h2[f_h2 > 1])
      F_h2[f_h2 > 1, f_h2 := 1]
   }

  z_h_h2 <- Ys[, lapply(.SD, sum, na.rm = TRUE), keyby = c(names(Ys)[1 : (2 + np)]),
                      .SDcols = names(Ys)[-(0 : (ncol(Y) + 2 + np))]]

  z_h_h2 <- merge(z_h_h2, F_h1, keyby = names(z_h_h2)[c(1 : (1 + np))])

  pop <- z_h_h2[[Nh1]]

  z_h_h2[, paste0(names(Y), "_sc") := lapply(.SD[, 
           paste0(names(Y), "_sc"), with = FALSE], function(x)
           x * pop ^ 2 * ( 1 / n_h1 - 1 / pop)/(n_h1 - 1))]

  z_h_h2[, paste0(names(Y), "_sd") := lapply(.SD[,
           paste0(names(Y), "_sd"), with = FALSE], function(x) 
                 (1 / n_h1) * x ^ 2  * pop ^ 2 * (1 / n_h1 - 1 / pop)/(n_h1 - 1))]

  z_h_h2[n_h1 == 1, paste0(names(Y), "_sc") := NA]
  z_h_h2[n_h1 == 1, paste0(names(Y), "_sd") := NA]

  nameszh2 <- names(H2)
  if (!is.null(period)) nameszh2 <- c(names(period), nameszh2)
  
  zh2 <- z_h_h2[, lapply(.SD, sum, na.rm = TRUE), keyby = nameszh2,
                      .SDcols = names(z_h_h2)[-(1 : (2 + np))]] 

  zh2 <- merge(zh2, F_h2, by = nn_h2)
  pop2 <- zh2[[names(N_h2)[ncol(N_h2)]]]
  nh2 <- zh2[["n_h2"]]
  f_h2 <- zh2[["f_h2"]]

  # s2
  s2_g <- zh2[, mapply(function(sa, sb, sc, sd) sa / (pop2 - 1) - pop2 / (pop2 - 1) * ((sb / pop2)^2 - (sc - sd) / pop2^2),
              zh2[, paste0(names(Y), "_sa"), with = FALSE], 
              zh2[, paste0(names(Y), "_sb"), with = FALSE],
              zh2[, paste0(names(Y), "_sc"), with = FALSE],
              zh2[, paste0(names(Y), "_sd"), with = FALSE])]

  # var_g 
  if (is.null(nrow(s2_g))) s2_g <- t(s2_g)
  s2_g <- data.table(s2_g)
  setnames(s2_g, names(s2_g), names(Y))

  s2g <- data.table(zh2[, nn_h2, with = FALSE], s2_g)

  s2_g <- matrix(pop2^2 * 1 / nh2 * (1 - f_h2)) * s2_g

  if (np > 0) s2_g <- data.table(zh2[, names(period), with = FALSE], s2_g)

  # Variance_est
  if (np == 0) {var_est <- data.table(t(colSums(s2_g, na.rm = TRUE)))
             } else var_est <- s2_g[, lapply(.SD, sum, na.rm = TRUE), 
                                              keyby = c(names(s2_g)[c(1 : np)]),
                                             .SDcols = names(Y)]
  list(s2g = s2g,
       var_est = var_est)
}