flt_con <- flt_connection(host = Sys.getenv("FLEET_HOST"),
                          apitoken = Sys.getenv("FLEET_TOKEN"))

test_that("get query list works!", {
  expect_equal(query_list(flt_con) |> ncol(), 22)
})

# test_that("get query list works with ... !", {
#   expect_equal(query_list(flt_con, "?query=safari_extensions") |> ncol(), 22)
# })
