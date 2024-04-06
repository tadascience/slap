#' Slap Operator
#'
#' @inheritParams rlang::eval_tidy
#' @inheritParams cli::cli_abort
#' @param keep_parent If TRUE, the caught error is kept as the parent error
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
#' @name slap
#' @export
`%!%` <- function(expr, message) {
  slap({{ expr}}, {{ message }}, env = caller_env(), keep_parent = TRUE)
}

#' @name slap
#' @export
`%!!%` <- function(expr, message) {
  slap({{ expr}}, {{ message }}, env = caller_env(), keep_parent = FALSE)
}

#' @export
slap <- function(expr, message, env = caller_env(), keep_parent = TRUE) {
  quo <- quo(
    withCallingHandlers(
      {{ expr }},
      error = function(err) {

        message <- {{ message }}
        if (is.function(message)) {
          message <- message(err)
        }

        error_call <- env$.__error_call__.
        if (is.null(error_call)) {
          error_call <- env$error_call
        }
        if (identical(error_call, rlang::error_call)) {
          error_call <- NULL
        }

        cli::cli_abort(message, parent = if (keep_parent) err, call = error_call)
      }
    )
  )

  eval_tidy(quo, env = env, data = list(env = env, keep_parent = keep_parent))
}

