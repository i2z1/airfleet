#' List queries
#'
#' @param flt_con connection object via flt_connection()
#' @param ...
#'
#' @return df
#' @export
#' @import dplyr
query_list <- function(flt_con, ...){
  res <- make_flt_req("/api/v1/fleet/queries", flt_con, ...)
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
