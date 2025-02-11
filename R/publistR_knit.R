#' publistR_knit
#'
#' @name publistR_knit
#' @rdname publistR_knit
#' @author Zheer Kejlberg Al-Mashhadi
#' @description Add author names to highlight in the publication list
#' @export
#' @usage publistR_knit()
#' @return NULL
#' @examples
#'   \dontrun{publistR_knit()}

#### publistR_knit(): Finalize process

publistR_knit <- function(author_names = NULL, ref_sections = NULL) {
  #### CREATE NECESSARY FILES ####
  # get filepaths
  csl_path <- system.file("publistR.csl", package = "publistR")
  bold_author_path <- system.file("bold-author.lua", package = "publistR")
  font_doc_path <- system.file("font-ref-doc.docx", package = "publistR")
  section_bibliographies_path <- system.file("section-bibliographies.lua", package = "publistR")

  # location to copy to
  to_path <- paste0(getwd(), "/publistR_temp")

  # create temp directory
  dir.create(to_path)

  # copy files
  file.copy(csl_path, to_path)
  file.copy(bold_author_path, to_path)
  file.copy(font_doc_path, to_path)
  file.copy(section_bibliographies_path, to_path)

  #### MODIFY YAML HEADER ####
  # Read YAML file
  yaml_path <- system.file("yaml.yaml", package = "publistR")
  yaml_data <- yaml::yaml.load_file(yaml_path)

  # add author names
  if (!is.null(author_names)) {
    yaml_data[["bold-auth-name"]] <- author_names
  }

  # fix the citeproc value
  verbatim_logical <- yaml::verbatim_logical
  yaml_data <- yaml::as.yaml(yaml_data, handlers = list(logical=verbatim_logical))

  # Write the modified YAML to a new file in the temp directory
  output_path <- paste0(getwd(), "/publistR_temp/yaml.txt")
  writeLines(yaml_data, output_path)

  # ADD REFERENCES
  if (is.null(DOIs)) {
    stop("No DOIs supplied")
  }
  #Get paper info by DOI
  message("Retrieving publication info from supplied DOIs.")
  extract_dois <- function(ref_sections) {
    rcrossref::cr_cn(ref_sections$DOIs)
  }
  bibtex <- lapply(ref_sections,extract_dois)
  message("DOIs retrieved.")

  # Create sections
  get_section_titles <- function(ref_sections) {
    ref_sections$title
  }
  ref_section_titles <- lapply(ref_sections,get_section_titles)

  sections <- c()
  for (i in 1:length(ref_section_titles)) {

    get_shorthand <- function(DOI) { sub(", title=.*$", "", sub("^ @article\\{", "", DOI)) }

    #sections <- c(sections, unlist(rrr[i]), unlist(ttt[i]))
    sections <- c(sections, "", paste0("# ", unlist(ref_section_titles[i])), "", paste0("@", get_shorthand(unlist(bibtex[i]))), "")
  }

  # Create .bib file
  bib <- unlist(bibtex)
  writeLines(bib, paste0(getwd(), "/publistR_temp/references.bib"))

  # Create .qmd file
  yaml_section <- readLines(paste0(getwd(), "/publistR_temp/yaml.txt"))
  qmd_file <- c("---",yaml_section, "---",sections)
  writeLines(qmd_file, paste0(getwd(), "/publistR_temp/publistR.qmd"))

  # Knit .qmd file
  quarto::quarto_render(paste0(getwd(), "/publistR_temp/publistR.qmd"))
}
