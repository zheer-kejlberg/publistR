#' create_bib
#'
#' @name create_bib
#' @rdname create_bib
#' @author Zheer Kejlberg Al-Mashhadi
#' @description INTERNAL
#' @keywords internal
#' @usage NULL
#' @export

create_bib <- function() {
  writeLines(bib, paste0(getwd(), "/publistR_temp/references.bib"))
}
