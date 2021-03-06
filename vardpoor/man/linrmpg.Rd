\name{linrmpg}

\alias{linrmpg}

\title{Linearization of the relative median at-risk-of-poverty gap}

\description{
  Estimate the relative median at-risk-of-poverty gap, which is defined as the relative difference between the median equalized disposable income of persons below the At Risk of Poverty Threshold and the At Risk of Poverty Threshold itself (expressed as a percentage of the at-risk-of-poverty threshold) and its linearization.
}

\usage{
  linrmpg(Y, id = NULL, weight = NULL,
          sort = NULL, Dom = NULL, period = NULL,
          dataset = NULL, percentage = 60,
          order_quant = 50L, var_name = "lin_rmpg",
          checking = TRUE)

}

\arguments{
  \item{Y}{Study variable (for example equalized disposable income). One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

  \item{id}{Optional variable for unit ID codes. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

  \item{weight}{Optional weight variable. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

  \item{sort}{Optional variable to be used as tie-breaker for sorting. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

  \item{Dom}{Optional variables used to define population domains. If supplied, linearization of the relative median at-risk-of-poverty gap is done for each domain. An object convertible to \code{data.table} or variable names as character vector, column numbers.}

  \item{period}{Optional variable for survey period. If supplied, linearization of the relative median at-risk-of-poverty gap is done for each time period. Object convertible to \code{data.table} or variable names as character, column numbers.}

  \item{dataset}{Optional survey data object convertible to \code{data.table}.}

  \item{percentage}{A numeric value in range \eqn{[0,100]} for \eqn{p} in the formula for poverty threshold computation:
  \deqn{\frac{p}{100} \cdot Z_{\frac{\alpha}{100}}.}{p/100 * Z(\alpha/100).}
  For example, to compute poverty threshold equal to 60\% of some income quantile, \eqn{p} should be set equal to 60.}
  
  \item{order_quant}{A integer value in range \eqn{[0,100]} for \eqn{\alpha} in the formula for poverty threshold computation:
  \deqn{\frac{p}{100} \cdot Z_{\frac{\alpha}{100}}.}{p/100 * Z(\alpha/100).}
  For example, to compute poverty threshold equal to some percentage of median income, \eqn{\alpha} should be set equal to 50.}

  \item{var_name}{A character specifying the name of the linearized variable.}

  \item{checking}{Optional variable if this variable is TRUE, then function checks data preparation errors, otherwise not checked. This variable by default is TRUE.}

}


\value{

A list with two objects are returned by the function:

\item{value}{A \code{data.table} containing the estimated relative median at-risk-of-poverty gap (in percentage).}
  
\item{lin}{A \code{data.table} containing the linearized variables of the relative median at-risk-of-poverty gap (in precentage).}
}


\references{
Working group on Statistics on Income and Living Conditions (2004) Common cross-sectional EU indicators based on EU-SILC; the gender pay gap.  \emph{EU-SILC 131-rev/04}, Eurostat.\cr
  
Guillaume Osier (2009). Variance estimation for complex indicators of poverty and inequality. \emph{Journal of the European Survey Research Association}, Vol.3, No.3, pp. 167-195, ISSN 1864-3361, URL \url{http://ojs.ub.uni-konstanz.de/srm/article/view/369}. \cr

Jean-Claude Deville (1999). Variance estimation for complex statistics and estimators: linearization and residual techniques. Survey Methodology, 25, 193-203, URL \url{http://www.statcan.gc.ca/pub/12-001-x/1999002/article/4882-eng.pdf}. \cr
}

\examples{
data(eusilc)
dati <- data.table(IDd = paste0("V", 1 : nrow(eusilc)), eusilc)

# Full population
d <- linrmpg(Y = "eqIncome", id = "IDd",
             weight = "rb050", Dom = NULL,
             dataset = dati, percentage = 60,
             order_quant = 50L)
d$value
d$threshold

\dontrun{
# By domains
dd <- linrmpg(Y = "eqIncome", id = "IDd",
              weight = "rb050", Dom = "db040",
              dataset = dati, percentage = 60,
              order_quant = 50L)
dd$value}
}

\seealso{
\code{\link{linarpt}}, \code{\link{linarpr}},  \code{\link{linpoormed}}, , \code{\link{varpoord}} , \code{\link{vardcrospoor}}, \code{\link{vardchangespoor}}}
\keyword{Linearization}

