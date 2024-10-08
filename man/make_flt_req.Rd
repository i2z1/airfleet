% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/connect.R
\name{make_flt_req}
\alias{make_flt_req}
\title{Generate request to API endpoint}
\usage{
make_flt_req(endpoint, flt_con, rtype = "GET", req_params = list())
}
\arguments{
\item{endpoint}{string, API path with params}

\item{flt_con}{connection object via flt_connection()}

\item{rtype}{request type}

\item{req_params}{list of request params}
}
\value{
list with deJSONed object
}
\description{
Generate request to API endpoint
}
