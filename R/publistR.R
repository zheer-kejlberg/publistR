#' publistR
#'
#' @name publistR
#' @rdname publistR
#' @author Zheer Kejlberg Al-Mashhadi
#' @description Create publication list
#' @export
#' @usage publistR()
#' @return NULL
#' @param author_names a list of lists containing author names to be highlighted. Each embedded list must have to keys "family =" and "given =" for sur- and firstname, respectively.
#' @param ref_sections a list of lists containing titles and DOIs for each section of the reference paper. Each embedded list must have two keys, "title =" and "DOIs =".
#' @param merge_sections a Boolean (defaults to FALSE) determining whether to merge all the supplied sections into one section with a common section title. For ease of use.
#' @param merged_title a section title for the merged section IF merge_sections is set to TRUE.
#' @examples
#'   \dontrun{publistR(
#'     author_names = list(
#'       list(family = "Kejlberg Al-Mashhadi", given = "Zheer"),
#'       list(family = "Kejlberg", given = "Zheer"),
#'       list(family = "Al-Mashhadi", given = "Zheer")
#'     ),
#'     ref_sections = list(
#'       list(title = "Section one", DOIs = c("10.21926/obm.geriatr.2002123","https://doi.org/10.1016/j.jacc.2019.06.057")),
#'       list(title = "Section two", DOIs = c("https://doi.org/10.1016/j.jacc.2019.06.057","https://doi.org/10.1016/j.jacc.2019.07.009"))
#'     )
#'   )}

#### publistR():

publistR <- function(author_names = NULL,
                     ref_sections = NULL,
                     merge_sections = FALSE,
                     merged_title = NULL) {
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
  if (is.null(ref_sections)) {
    stop("No DOIs supplied")
  }
  #Get paper info by DOI
  message("Retrieving publication info from supplied DOIs.")
  extract_dois <- function(ref_section) {
    rcrossref::cr_cn(ref_section$DOIs)
  }
  bibtex <- lapply(ref_sections,extract_dois)
  message("DOIs retrieved.")

  # Create sections
  get_section_titles <- function(ref_sections) {
    ref_sections$title
  }
  ref_section_titles <- lapply(ref_sections,get_section_titles)

  if (merge_sections == FALSE) {
    sections <- c()
  } else {
    sections <- c("", merged_title, "")
  }

  for (i in 1:length(ref_section_titles)) {

    get_shorthand <- function(DOI) { sub(", title=.*$", "", sub("^ @article\\{", "", DOI)) }

    if (merge_sections == FALSE) {
      sections <- c(sections, "", paste0("# ", unlist(ref_section_titles[i])), "", paste0("@", get_shorthand(unlist(bibtex[i]))), "")
    } else {
      sections <- c(sections, paste0("@", get_shorthand(unlist(bibtex[i]))), "")
    }

  }

  # Create .bib file
  bib <- unlist(bibtex)
  writeLines(bib, paste0(getwd(), "/publistR_temp/references.bib"))

  # Create .qmd file
  yaml_section <- readLines(paste0(getwd(), "/publistR_temp/yaml.txt"))
  qmd_file <- c("---",yaml_section, "---",sections)
  writeLines(qmd_file, paste0(getwd(), "/publistR.qmd"))

  # Knit .qmd file
  quarto::quarto_render(paste0(getwd(), "/publistR.qmd"))

  # Delete temp files
  file.remove("publistR.qmd")
  unlink("publistR_temp", recursive = TRUE)
}
