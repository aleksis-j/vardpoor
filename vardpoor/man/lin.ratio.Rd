\name{lin.ratio}

\alias{lin.ratio}

\title{Linearization of the ratio estimator}

\description{Computes linearized variable for the ratio estimator.}

\usage{lin.ratio(Y, Z, weight, Dom = NULL, dataset = NULL, percentratio = 1, checking = TRUE)}

\arguments{

\item{Y}{Matrix of numerator variables. Any object convertible to \code{data.table} with numeric values, \code{NA} values are not allowed.}

\item{Z}{Matrix of denominator variables. Any object convertible to \code{data.table} with numeric values, \code{NA} values are not allowed.}

\item{weight}{Weight variable. One dimensional object convertible to one-column \code{data.table}.}

\item{Dom}{Optional variables used to define population domains. If supplied, the linearized variables are computed for each domain. An object convertible to \code{data.table}.}

\item{dataset}{Optional survey data object convertible to \code{data.table}.}

\item{percentratio}{Positive integer value. All linearized variables are multiplied with percentratio value, by default - 1.}

\item{checking}{Optional variable if this variable is TRUE, then function checks data preparation errors, otherwise not checked. This variable by default is TRUE.}
}

\value{The function returns the \code{data.table} of the linearized variables for the ratio estimator.}

\references{ 
Carl-Erik Sarndal, Bengt Swensson, Jan Wretman. Model Assisted Survey Sampling. Springer-Verlag, 1992, p.178.
}

\examples{
Y <- data.table(Y = rchisq(10, 3))
Z <- data.table(Z = rchisq(10, 3))
weights <- rep(2, 10)
data.table(Y, Z, weights, 
           V1 = lin.ratio(Y, Z, weights, percentratio = 1),
           V10 = lin.ratio(Y, Z, weights, percentratio = 10),
           V100 = lin.ratio(Y, Z, weights, percentratio = 100))
}

\seealso{
  \code{\link{domain}},
  \code{\link{vardom}},
  \code{\link{vardomh}},
  \code{\link{vardcros}},
  \code{\link{vardchanges}},
  \code{\link{vardannual}}
}

\keyword{survey}
