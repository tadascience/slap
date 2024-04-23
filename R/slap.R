#' Slap Operator
#'
#' @param expr An expression or quosure to evaluate carefully
#' @param message A message meant to be formatted by [cli::cli_bullets()] or a
#'   function.
#'
#' @return If `expr` succeeds, its result is returned.
#'
#' When `expr` generates an error, the `%!%` and `%!!%` operators
#' catch it and embed it in a new error thrown by [cli::cli_abort()].
#'
#' If `message` evaluates to a character vector, it is used as the
#' `message` argument of [cli::cli_abort()].
#'
#' If `message` evaluates to a function, the function is called with one
#' argument: the caught error from evaluating `expr`.
#'
#' When the current environment has an `error_call` object, it is
#' used as the `call` argument of [cli::cli_abort()].
#'
#' @examples
#' # g() throws an error
#' g <- function() {
#'   stop("ouch")
#' }
#'
#' # h() catches that error and embed it in a new error
#' # with "bam" as its message, the g() error as the parent error,
#' # and the caller environment as call=
#' h <- function(error_call = rlang::caller_env()) {
#'   g() %!% "bam"
#' }
#'
#' # f() will be used as the error call
#' f <- function() {
#'   h()
#' }
#'
#' # Error in `f()`:
#' # ! bam
#' # Caused by error in `g()`:
#' # ! ouch
#' tryCatch(f(), error = function(err) {
#'   print(err, backtrace = FALSE)
#' })
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

        cli::cli_abort(message, parent = if (keep_parent) err, call = error_call)
      }
    )
  )

  eval_tidy(quo, env = env, data = list(env = env, keep_parent = keep_parent))
}
