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
#' @name slap
#' @export
`%!%` <- function(expr, message) {
  message <- enexpr(message)

  quo <- quo(
    withCallingHandlers(
      {{ expr }},
      error = function(.__slap__.) {
        message <- !!message

        error_call <- env$.__error_call__.
        if (is.null(error_call)) {
          error_call <- env$error_call
        }
        if (identical(error_call, rlang::error_call)) {
          error_call <- NULL
        }

        cli::cli_abort(message, parent = .__slap__., call = error_call)
      }
    )
  )

  env <- caller_env()
  eval_tidy(quo, env = env, data = list(env = env))
}

#' @export
slap <- function(error_call = current_env()) {
  get(".__slap__.", caller_env()) %||% cli_abort("{.fn slap()} can only be used on the rhs of a `%!%`.", call = error_call)
}
