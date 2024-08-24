#' List queries
#'
#' @param flt_con connection object via flt_connection()
#' @param req_params opt, if provided specifies extra params, i.e. req_params = list(query = "darwin", order_direction = "desc")
#'
#' @return df
#' @export
#' @import dplyr
query_list <- function(flt_con, req_params = list()){
  res <- make_flt_req("/api/v1/fleet/queries", flt_con, req_params = req_params)
  if(!is.null(res$queries) & length(res$queries)>0){
    queries <- res$queries |>
      lapply(unlist) |>
      do.call(rbind, args = _) |>
      as.data.frame() |>
      mutate(across(ends_with("ed_at"), function(x) as.POSIXct(x, tz = "UTC", format = "%Y-%m-%dT%H:%M:%SZ"))) |>
      mutate(across(c("interval", "stats.total_executions"), as.numeric)) |>
      mutate(across(c("automations_enabled", "saved", "observer_can_run"), as.logical))
  } else {
    queries <- NA
  }
  return(queries)
}

query_create <- function(flt_con, name, query, desc = "", params = list()){

  params <- append(params, list(name = name, query = query, description = desc))
  res <- make_flt_req("/api/v1/fleet/queries", flt_con, rtype = "POST", req_params = params)

  if(!is.null(res$query) & length(res$query)>0){
    res$query[["stats"]] <- NULL
    answer <- res$query |>
      #lapply(unlist) |>
      do.call(cbind, args = _) |>
      as.data.frame()
  } else {
    answer <- NA
  }

  return(answer)
}

#' Delete Fleet query by id
#'
#' @param flt_con connection object via flt_connection()
#' @param id Fleet query id, can be fetched via query_list() function
#'
#' @return TRUE if success, else FALSE
#' @export
#' @import httr2
query_delete <- function(flt_con, id){

  flt_url <- paste0("https://", flt_con$host, ":", flt_con$port)

  res <- tryCatch({
    httr2::request(flt_url) |>
      httr2::req_method("DELETE") |>
      httr2::req_url_path_append("/api/v1/fleet/queries/id/") |>
      httr2::req_url_path_append(id) |>
      httr2::req_auth_bearer_token(flt_con$token) |>
      httr2::req_perform()

    TRUE
  },
  error = function(err){
    print(paste("Web response:", err$status))
    FALSE
  })

  return(res)

}
