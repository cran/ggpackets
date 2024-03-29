#' Convert an expression into a call as a list of quosure components
#'
#' @param x An expression to convert to a ggcall.
#' @param which The relative frame offset in which the expression should be
#' eventually evaluated.
#'
#' @importFrom rlang quos enquo quo_get_expr quo_set_env
#' @importFrom ggplot2 standardise_aes_names
#'
#' @keywords internal
#'
as_gg_call <- function(x, which = -3L) {
  xexpr <- eval(bquote(
    substitute(.(substitute(x)))),
    envir = parent.frame(-which - 1L))

  xids <- c()
  if (is.call(xexpr)) {
    xexpr <- expand_dots(xexpr, parent.frame(-which))
    xcall <- do.call(rlang::quos, as.list(xexpr), envir = parent.frame(-which))
    names(xcall)[-1] <- ggplot2::standardise_aes_names(names(xcall)[-1])
    if (".id" %in% names(xcall)[-1]) {
      xids <- rlang::eval_tidy(xcall[[".id"]])
      xcall <- xcall[c(1, 1 + which(names(xcall[-1]) != ".id"))]
    }
    xcallname <- infer_ggcall_name(rlang::quo_get_expr(xcall[[1]]))
  } else {
    xcall <- rlang::quo_set_env(rlang::enquo(xexpr), parent.frame(-which - 1L))
    xcallname <- infer_ggcall_name(rlang::quo_get_expr(xcall))
  }

  xcall <- list(structure(
    list(xcall),
    ids = if (length(xids)) xids else infer_ggcall_id(xcallname),
    class = c("ggcall", "list")
  ))
  names(xcall) <- xcallname
  xcall
}



#' Label ggcall with function name if it can be deduced
#'
#' @param expr An expression from which a call name should be inferred.
#'
#' @keywords internal
#'
infer_ggcall_name <- function(expr) {
  # TODO: prohibit names ambiguous with gg args with dots
  #       (inherit.aes, na.rm, show.legend, fun.data, label.r)
  if (is.name(expr) && grepl("\\w", expr)) as.character(expr)
  else "layer"
}



#' Convert ggplot geom layers to friendly names
#'
#' @param x A function name from which an id should be inferred.
#'
#' @keywords internal
#'
infer_ggcall_id <- function(x) {
  gsub("^(geom|stat)_", "", x)
}
