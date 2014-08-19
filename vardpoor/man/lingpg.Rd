\name{lingpg}

\alias{lingpg}

\title{Linearization of the gender pay (wage) gap.}

\description{
  Estimate the gender pay (wage) gap and its linearization.
}

\usage{
lingpg(inc, gender = NULL, id, 
       weight=NULL, sort = NULL,
       Dom = NULL, period=NULL,
       dataset = NULL, na.rm=FALSE,
       var_name="lin_gpg")
}

\arguments{

  \item{inc}{Study variable (for example equalized disposable income). One dimensional object convertible to one-column \code{data.frame} or variable name as character, column number or logical vector with only one \code{TRUE} value (length of the vector has to be the same as the column count of \code{dataset}).}

  \item{gender}{Factor variable for gender. One dimensional object convertible to one-column \code{data.frame} or variable name as character, column number or logical vector with only one \code{TRUE} value (length of the vector has to be the same as the column count of \code{dataset}).}

  \item{id}{Optional variable for unit ID codes. One dimensional object convertible to one-column \code{data.frame} or variable name as character, column number or logical vector with only one \code{TRUE} value (length of the vector has to be the same as the column count of \code{dataset}).}

  \item{weight}{Optional weight variable. One dimensional object convertible to one-column \code{data.frame} or variable name as character, column number or logical vector with only one \code{TRUE} value (length of the vector has to be the same as the column count of \code{dataset}).}

  \item{sort}{Optional variable to be used as tie-breaker for sorting. One dimensional object convertible to one-column \code{data.frame} or variable name as character, column number or logical vector with only one \code{TRUE} value (length of the vector has to be the same as the column count of \code{dataset}).}

  \item{Dom}{Optional variables used to define population domains. If supplied, linearization of the gender pay (wage) gap is done for each domain. An object convertible to \code{data.frame} or variable names as character vector, column numbers or logical vector (length of the vector has to be the same as the column count of \code{dataset}).}

  \item{period}{Optional variable for survey period. If supplied, linearization of the gender pay (wage) gap is done for each time period. Object convertible to \code{data.frame} or variable names as character, column numbers or logical vector (length of the vector has to be the same as the column count of \code{dataset}).}

  \item{dataset}{Optional survey data object convertible to \code{data.frame}.}

  \item{na.rm}{A logical value indicating whether missing values in study variable should be removed.}

  \item{var_name}{A character specifying the name of the linearized variable.}
}


\value{
  A list with two objects are returned by the function:
  
  \item{value}{A \code{data.frame} containing the estimated gender pay (wage) gap (in percentage).}
  
  \item{lin}{A \code{data.frame} containing the linearized variables of the gender pay (wage) gap (in percentage)..}
}


\references{
Working group on Statistics on Income and Living Conditions (2004) Common cross-sectional EU indicators based on EU-SILC; the gender pay gap. \emph{EU-SILC 131-rev/04}, Eurostat.\cr
  
Guillaume Osier (2009). Variance estimation for complex indicators of poverty and inequality. \emph{Journal of the European Survey Research Association}, Vol.3, No.3, pp. 167-195, ISSN 1864-3361, URL \url{https://ojs.ub.uni-konstanz.de/srm/article/view/369}. \cr

Jean-Claude Deville (1999). Variance estimation for complex statistics and estimators: linearization and residual techniques. Survey Methodology, 25, 193-203, URL \url{http://www5.statcan.gc.ca/bsolc/olc-cel/olc-cel?lang=eng&catno=12-001-X19990024882}. \cr
}

\examples{
data(ses)
dati=data.frame(1:nrow(ses),ses)
colnames(dati)[1]<-"ID"
gpgs2<-lingpg(inc="earningsHour", gender="sex",
              id="ID", weight="weights",
              Dom="education", dataset=dati)
gpgs2$value
}

\seealso{
\code{\link{linqsr}}, \code{\link{lingini}}, \code{\link{varpoord}}}
\keyword{Linearization}

