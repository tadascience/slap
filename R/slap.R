#' Slap Operator
#'
#' @inheritParams rlang::eval_tidy
#' @inheritParams cli::cli_abort
#'
#' @examples
#' g <- function() {
#'   stop("ouch")
#' }
#' f <- function(error_call = current_env()) {
#'   g() %!% "bam"
#' }
#' h <- function() {
#'   rlang::local_error_call(quote(foo()))
#'
#'   g() %!% "bam"
#' }
#'
#' \dontrun{
#'   f()
#'   h()
#' }
#'
#' @rdname slap
#' @export
`%!%` <- function(expr, message, env = caller_env()) {
  expr <- enquo(expr)
  or <- enquo(message)

  quo <- quo(
    withCallingHandlers(
      !!expr,
      error = function(err) {
        message <- !!message
        error_call <- frame$.__error_call__. %||% frame$error_call
        if (identical(error_call, rlang::error_call)) {
          error_call <- NULL
        }
        cli::cli_abort(message, parent = err, call = error_call)
      }
    )
  )
  eval_tidy(quo, env = env, data = list(frame = env))
}
