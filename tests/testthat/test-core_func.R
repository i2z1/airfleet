flt_con <- flt_connection(host = Sys.getenv("FLEET_HOST"),
               apitoken = Sys.getenv("FLEET_TOKEN"))

test_that("get Fleet hosts works", {
  expect_equal(get_hosts(flt_con) |> ncol(), 51)
})
