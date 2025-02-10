#' publistR_section
#'
#' @name publistR_section
#' @rdname publistR_section
#' @author Zheer Kejlberg Al-Mashhadi
#' @description Create section for the publication list
#' @export
#' @usage publistR_section(title = "Section title", DOIs = c("vector of DOIs"))
#' @param title The title of the section
#' @param DOIs A DOI or list of DOIs for the papers in the section
#' @return NULL
#' @examples
#'   \dontrun{publistR_section(title = "First authorship", DOIs = "https://doi.org/10.1016/j.jacc.2019.06.057")}

#### publistR_section(): Create section for the publication list

publistR_section <- function(title, DOIs) {
  # Get paper info by DOI
  message("Retrieving publication info from supplied DOIs.")
  bibtex <- rcrossref::cr_cn(DOIs)
  message("DOIs retrieved.")

  # Create sections
  if (!exists("sections")) {sections <<- c()}
  get_shorthand <- function(DOI) { sub(", title=.*$", "", sub("^ @article\\{", "", DOI)) }
  sections <<- c(sections, "", paste0("# ", title), "", paste0("@", get_shorthand(bibtex)), "")

  # Add .bib data
  if (!exists("bib")) {bib <<- c()}
  bib <<- c(bib, unlist(bibtex))
}
