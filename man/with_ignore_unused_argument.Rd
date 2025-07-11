% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils_arguments.R
\name{with_ignore_unused_argument}
\alias{with_ignore_unused_argument}
\title{Evaluate a call, ignore base R errors for unused arguments}
\usage{
with_ignore_unused_argument(call, envir = parent.frame())
}
\arguments{
\item{call}{A call to evaluate.}

\item{envir}{An environment to evaluate the given expression in.}
}
\description{
In actuality, the expression is repeatedly called while catching errors and
removing error-causing arguments.
}
