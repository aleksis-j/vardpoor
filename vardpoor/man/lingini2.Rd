\name{lingini2}

\alias{lingini2}

\title{Linearization of the GINI coefficient II}

\description{
  Estimate the Gini coefficient, which is a measure for inequality, and its linearization.
}

\usage{
lingini2(Y, id = NULL, weight = NULL,
         sort = NULL, Dom = NULL,
         period = NULL, dataset = NULL,
         var_name = "lin_gini2",
         checking = TRUE)
}

\arguments{

  \item{Y}{Study variable (for example equalized disposable income). One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

  \item{id}{Optional variable for unit ID codes. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

  \item{weight}{Optional weight variable. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

  \item{sort}{Optional variable to be used as tie-breaker for sorting. One dimensional object convertible to one-column \code{data.table} or variable name as character, column number.}

  \item{Dom}{Optional variables used to define population domains. If supplied, linearization of the GINI is done for each domain. An object convertible to \code{data.table} or variable names as character vector, column numbers.}

  \item{period}{Optional variable for survey period. If supplied, linearization of the GINI is done for each time period. Object convertible to \code{data.table} or variable names as character, column numbers.}

  \item{dataset}{Optional survey data object convertible to \code{data.table}.}

  \item{var_name}{A character specifying the name of the linearized variable.}

  \item{checking}{Optional variable if this variable is TRUE, then function checks data preparation errors, otherwise not checked. This variable by default is TRUE.}

}

\value{
 A list with two objects are returned by the function:

  \item{value}{A \code{data.table} containing the estimated Gini coefficients (in percentage) by Langel and Tille (2012) and Eurostat.}
  
  \item{lin}{A \code{data.table} containing the linearized variables of the Gini coefficients (in percentage) by Langel and Tille (2012).}

}

\references{
Eric Graf and Yves Tille, Variance Estimation Using Linearization for Poverty and Social Exclusion Indicators,  Survey Methodology, June 2014 61 Vol. 40, No. 1, pp. 61-79, Statistics Canada, Catalogue no. 12-001-X, 
URL \url{http://www.statcan.gc.ca/pub/12-001-x/12-001-x2014001-eng.pdf}\cr

Jean-Claude Deville (1999). Variance estimation for complex statistics and estimators: linearization and residual techniques. Survey Methodology, 25, 193-203, URL \url{http://www.statcan.gc.ca/pub/12-001-x/1999002/article/4882-eng.pdf}. \cr

MATTI LANGEL - YVES TILLE, Corrado Gini, a pioneer in balanced sampling and inequality theory. \emph{METRON - International Journal of Statistics}, 2011, vol. LXIX, n. 1, pp. 45-65, URL \url{ftp://metron.sta.uniroma1.it/RePEc/articoli/2011-1-3.pdf}. \cr

Working group on Statistics on Income and Living Conditions (2004) Common cross-sectional EU indicators based on EU-SILC; the gender pay gap.  \emph{EU-SILC 131-rev/04}, Eurostat.\cr

}

\examples{
data(eusilc)
dati <- data.table(IDd = paste0("V", 1 : nrow(eusilc)), eusilc)

# Full population
dat1 <- lingini2(Y = "eqIncome", id = "IDd", weight = "rb050",  dataset = dati)
dat1$value

\dontrun{
# By domains
dat2 <- lingini2(Y = "eqIncome", id = "IDd", weight = "rb050", Dom = c("db040"), dataset = dati)
dat2$value}
}

\seealso{
\code{\link{lingini}}, \code{\link{linqsr}}, \code{\link{varpoord}} , \code{\link{vardcrospoor}}, \code{\link{vardchangespoor}}}
\keyword{Linearization}
