fltcon <- flt_connection(host = Sys.getenv("FLEET_HOST"),
               apitoken = Sys.getenv("FLEET_TOKEN"))

test_that("hosts works", {
  expect_equal(get_hosts(fltcon) |> ncol(), 49)
})
