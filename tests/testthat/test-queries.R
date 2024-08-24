flt_con <- flt_connection(host = Sys.getenv("FLEET_HOST"),
                          apitoken = Sys.getenv("FLEET_TOKEN"))

test_that("func query_list() works!", {
  expect_equal(query_list(flt_con) |> ncol(), 22)
})


test_that("func query_create() works!", {
  expect_equal(query_create(flt_con, name = "test2", query = "SELECT * from users;") |> ncol(), 17)
})

test_that("get query_delete() works!", {
  query_create(flt_con, name = "test3", query = "SELECT * from users;")
  test_qry_ids <- query_list(flt_con) |>
    filter(grepl("test\\d", name)) |>
    select(id) |>
    unlist()
  expect_equal(sapply(test_qry_ids, \(x){query_delete(flt_con, x)}) |> all(), TRUE)
})
