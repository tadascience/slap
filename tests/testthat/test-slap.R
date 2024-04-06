test_that("%!% works", {
  f <- function() {
    cli::cli_abort("ouch")
  }
  g <- function(error_call = current_env()) {
    f() %!% "bam {.code boom()}"
  }
  h <- function() {
    local_error_call(quote(foo()))
    f() %!% "bam {.code boom()}"
  }
  expect_snapshot(error = TRUE, stop("ouch") %!% "bam")
  expect_snapshot(error = TRUE, g())
  expect_snapshot(error = TRUE, h())

})
