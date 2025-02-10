#' add_author_name
#'
#' @name add_author_name
#' @rdname add_author_name
#' @author Zheer Kejlberg Al-Mashhadi
#' @description Add author names to highlight in the publication list
#' @export
#' @usage add_author_name(family = "Family Name", given = "Firstname")
#' @param family Input surname as character
#' @param given Input firstname as character
#' @return NULL
#' @examples
#'   \dontrun{add_author_name(family = "Family Name", given = "Firstname")}

#### add_author_name(): Add author names to highlight in the publication list

add_author_name <- function(family, given) {
  if (!exists("namelist")) {namelist <<- list()}
  namelist[[length(namelist) + 1]] <<- list(family = family, given = given)
}
