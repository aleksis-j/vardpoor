\name{vardom_othstr}
\alias{vardom_othstr}

\title{Variance estimation for sample surveys in domain by the two stratification}

\description{Computes the variance estimation for sample surveys in domain by the two stratification.}

\usage{vardom_othstr(Y, H, H2, PSU, w_final, id = NULL,
       Dom = NULL, period=NULL, N_h = NULL,
       N_h2, Z = NULL,
       X = NULL, g = NULL, q = NULL, dataset = NULL, 
       confidence = .95,  percentratio=1, 
       outp_lin=FALSE, outp_res=FALSE)}

\arguments{

\item{Y}{Variables of interest. Object convertible to \code{data.table} or variable names as character, column numbers.}

\item{H}{The unit stratum variable. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

\item{H2}{The unit new stratum variable. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

\item{PSU}{Primary sampling unit variable. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

\item{w_final}{Weight variable. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

\item{id}{Optional variable for unit ID codes. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

\item{Dom}{Optional variables used to define population domains. If supplied, linearization of the at-risk-of-poverty rate is done for each domain. An object convertible to \code{data.table} or variable names as character vector, column numbers.}

\item{period}{Optional variable for survey period. If supplied, residual estimation of calibration is done independently for each time period. One dimensional object convertible to one-column \code{data.table}.}

\item{N_h}{optional data object convertible to \code{data.table}. If period is supplied, the time period is at the beginning of the object and after time period in the object is stratum. If period is not supplied, the first column in the object is stratum. In the last column is the total of the population in each stratum.}

\item{N_h2}{optional data object convertible to \code{data.table}. If period is supplied, the time period is at the beginning of the object and after time period in the object is new stratum. If period is not supplied, the first column in the object is new stratum. In the last column is the total of the population in each stratum.}

\item{Z}{optional variables of denominator for ratio estimation. Object convertible to \code{data.table} or variable names as character, column numbers.}

\item{X}{Optional matrix of the auxiliary variables for the calibration estimator. Object convertible to \code{data.table} or variable names as character, column numbers.}

\item{g}{Optional variable of the g weights. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

\item{q}{Variable of the positive values accounting for heteroscedasticity. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

\item{dataset}{Optional survey data object convertible to \code{data.table}.}

\item{confidence}{Optional positive value for confidence interval. This variable by default is 0.95.}

\item{percentratio}{Positive numeric value. All linearized variables are multiplied with \code{percentratio} value, by default - 1.}

\item{outp_lin}{Logical value. If \code{TRUE} linearized values of the ratio estimator will be printed out.}

\item{outp_res}{Logical value. If \code{TRUE} estimated residuals of calibration will be printed out.}

}

\value{

  A list with objects are returned by the function:

  \item{lin_out}{A \code{data.table} containing the linearized values of the ratio estimator with id and PSU.}

  \item{res_out}{A \code{data.table} containing the estimated residuals of calibration with id and PSU.}

  \item{s2g}{A \code{data.table} containing the s^2g value.}

  \item{all_result}{A \code{data.table}, which containing variables:

       \code{respondent_count} - the count of respondents, \cr
       \code{pop_size} - the estimated size of population, \cr
       \code{n_nonzero} - the count of respondents, who answers are larger than zero, \cr
       \code{estim} - the estimated value, \cr
       \code{var} - the estimated variance, \cr
       \code{se} - the estimated standard error, \cr
       \code{rse} - the estimated relative standard error (coefficient of variation), \cr
       \code{cv} - the estimated relative standard error (coefficient of variation) in percentage, \cr
       \code{absolute_margin_of_error} - the estimated absolute margin of error, \cr
       \code{relative_margin_of_error} - the estimated relative margin of error in percentage, \cr
       \code{CI_lower} - the estimated confidence interval lower bound, \cr
       \code{CI_upper} - the estimated confidence interval upper bound, \cr
       \code{var_srs_HT} - the estimated variance of the HT estimator under SRS, \cr
       \code{var_cur_HT} - the estimated variance of the HT estimator under current design, \cr
       \code{var_srs_ca} - the estimated variance of the calibrated estimator under SRS, \cr
       \code{deff_sam} - the estimated design effect of sample design, \cr
       \code{deff_est} - the estimated design effect of estimator, \cr
       \code{deff} - the overall estimated design effect of sample design and estimator}

}

\references{
  Jean-Claude Deville (1999). Variance estimation for complex statistics
  and estimators: linearization and residual techniques. Survey
  Methodology, 25, 193-203, URL \url{http://www.statcan.gc.ca/pub/12-001-x/1999002/article/4882-eng.pdf}. \cr

  M. Liberts. (2004) Non-response Analysis and Bias Estimation in a Survey on Transportation of Goods by Road.  \cr
}

\examples{

data(eusilc)

# Example 1
eusilc1 <- eusilc[1:1000, ]
dataset <- data.table(IDd = paste0("V", 1:nrow(eusilc1)), eusilc1)
dataset[, db040_2 := get("db040")]
N_h2 <- dataset[, sum(rb050, na.rm = FALSE), keyby = "db040_2"]

aa<-vardom_othstr(Y = "eqIncome", H = "db040", H2 = "db040_2",  
                  PSU = "db030", w_final = "rb050", id = "rb030",
                  Dom = "db040", period = NULL, N_h = NULL,
                  N_h2 = N_h2, Z = NULL, X = NULL, g = NULL,
                  q = NULL, dataset = dataset, confidence = .95,           
                  outp_lin = TRUE, outp_res = TRUE)


\dontrun{
# Example 2
dataset <- data.table(IDd = 1:nrow(eusilc), eusilc)
dataset[, db040_2 := get("db040")]
N_h2 <- dataset[, sum(rb050, na.rm = FALSE), keyby = "db040_2"]

aa <- vardom_othstr(Y = "eqIncome", H = "db040", H2 = "db040_2",
                    PSU = "db030", w_final = "rb050", id = "rb030",
                    Dom = "db040", period = NULL, N_h2 = N_h2,
                    Z = NULL, X = NULL, g = NULL, dataset = dataset,
                    q = NULL, confidence = .95, outp_lin = TRUE,
                    outp_res = TRUE)
}

}
\seealso{
\code{\link{domain}},   \code{\link{lin.ratio}},  \code{\link{residual_est}},
\code{\link{vardomh}},  \code{\link{var_srs}},    \code{\link{variance_est}},
\code{\link{variance_othstr}}}
\keyword{vardpoor}
