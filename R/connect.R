#' Make connection object
#'
#' @param host Fleet host
#' @param port Fleet port (default 443)
#' @param apitoken Fleet instance API token
#'
#' @return con object
#' @export
flt_connection <- function(host = "127.0.0.1",
                            port = 443,
                            apitoken){
  list(host = host,
       port = port,
       token = apitoken)
}

#' Generate request to API endpoint
#'
#' @param endpoint string, API path with params
#' @param flt_con connection object via flt_connection()
#' @param ...
#'
#' @return list with deJSONed object
#' @export
#' @import httr2
make_flt_req <- function(endpoint, flt_con, ...){
  flt_url <- paste0("https://", flt_con$host, ":", flt_con$port)
  endpoint_params <- paste0(endpoint, ...)

  ans <- httr2::request(flt_url) |>
    httr2::req_url_path_append(endpoint_params) |>
    httr2::req_auth_bearer_token(flt_con$token) |>
    httr2::req_perform()

  ans_list <- ans |>
    httr2::resp_body_json()

  return(ans_list)

}

#' Get hosts
#'
#' @param flt_con connection object
#'
#' @return df
#' @export
#' @import dplyr
get_hosts <- function(flt_con){
  res <- make_flt_req("/api/v1/fleet/hosts", flt_con)

  hosts_df <- res$hosts |>
    lapply(unlist) |>
    do.call(rbind, args = _) |>
    as.data.frame() |>
    mutate(across(ends_with("ed_at"), function(x) as.POSIXct(x, tz = "UTC", format = "%Y-%m-%dT%H:%M:%SZ"))) |>
    mutate(across(c("memory", "uptime", ends_with("_cores"),
                    contains(c("disk_space", "interval", "tls", "count"))), as.numeric))

  return(hosts_df)
}
