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
#' @param custom_fonts File path to a custom Quarto Word Template (for adjusting the output fonts). The fonts to set are Heading 1, Hyperlink and Body Text/First Paragraph. Arg defaults to 'NULL', using PublistR's internal Word Template.
#' @param title_bold Boolean, defaults to FALSE
#' @param title_italic Boolean, defaults to FALSE
#' @param title_underline Boolean, defaults to FALSE
#' @param title_small_caps Boolean, defaults to FALSE
#' @examples
#'   \dontrun{
#'   publistR(
#'     author_names = list(
#'       list(family = "Al-Mashhadi", given = "Zheer"),
#'       list(family = "Al-Mashhadi", given = "Zheer Kejlberg")
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
                     merged_title = NULL,
                     custom_fonts = NULL,
                     title_bold = FALSE,
                     title_italic = FALSE,
                     title_underline = FALSE,
                     title_small_caps = FALSE
                     ) {
  # ERROR HANDLING
  if (is.null(ref_sections)) {
    stop("No DOIs supplied")
  }
  if (merge_sections == TRUE & is.null(merged_title)) {
    stop("merge_sections argument set to TRUE but no input supplied to the merged_title argument. The merged section must have a title.")
  }
  # check keys for author_names
  check_author_name_keys <- function(input) {
    input == c("family", "given")
  }
  if (!all(unlist(lapply(lapply(author_names, names), check_author_name_keys)))) {
    stop("Author names keys not specified correctly. Make sure there are only key pairs of 'family' and 'given'.")
  }
  # check keys for ref_sections
  check_ref_sections_keys <- function(input) {
    input == c("title", "DOIs")
  }
  if (!all(unlist(lapply(lapply(ref_sections, names), check_ref_sections_keys)))) {
    stop("Ref_section keys not specified correctly. Make sure there are only key pairs of 'title' and 'DOIs'.")
  }
  # Check if custom_fonts word template exists
  if (!is.null(custom_fonts)) {
    if (!file.exists(custom_fonts)) {
      stop(paste0("Check that the required Word Template exists at ", custom_fonts))
    }
  }


  #### CREATE NECESSARY FILES ####
  # get filepaths
  csl_path <- system.file("publistR.csl", package = "publistR")
  bold_author_path <- system.file("bold-author.lua", package = "publistR")
  hide_me_path <- system.file("hide-me.lua", package = "publistR")
  if (!is.null(custom_fonts)) {
    font_doc_path <- custom_fonts
  } else {
    font_doc_path <- system.file("font-ref-doc.docx", package = "publistR")
  }
  section_bibliographies_path <- system.file("section-bibliographies.lua", package = "publistR")

  # location to copy to
  to_path <- paste0(getwd(), "/publistR_temp")

  # create temp directory
  dir.create(to_path)

  # copy files
  file.copy(bold_author_path, to_path)
  file.copy(hide_me_path, to_path)
  file.copy(font_doc_path, to_path)
  file.copy(section_bibliographies_path, to_path)

  #### MODIFY CSL ####
  csl <- readLines(csl_path)
  input_formatting <- function(input) {
    for (line in c(534,540,546,549,554)) {
      csl[line] <- gsub("/>", paste0(" ", input," />"), csl[line])
    }
    return(csl)
  }
  if (title_bold) { csl <- input_formatting("font-weight=\"bold\"") }
  if (title_italic) { csl <- input_formatting("font-style=\"italic\"") }
  if (title_underline) { csl <- input_formatting("text-decoration=\"underline\"") }
  if (title_small_caps) { csl <- input_formatting("font-variant=\"small-caps\"") }
  writeLines(csl, paste0(to_path, "/publistR.csl"))

  #### MODIFY YAML HEADER ####
  # Read YAML file
  yaml_path <- system.file("yaml.yaml", package = "publistR")
  yaml_data <- yaml::yaml.load_file(yaml_path)

  # add author names
  if (!is.null(author_names)) {
    yaml_data[["bold-auth-name"]] <- author_names
  }

  # fix the citeproc value
  yaml_data <- yaml::as.yaml(yaml_data, handlers = list(logical=yaml::verbatim_logical))

  # Write the modified YAML to a new file in the temp directory
  output_path <- paste0(getwd(), "/publistR_temp/yaml.txt")
  writeLines(yaml_data, output_path)

  #### ADD REFERENCES ####
  #Get paper info by DOI
  message("Retrieving publication info from supplied DOIs.")
  extract_dois <- function(ref_section) {
    rcrossref::cr_cn(ref_section$DOIs)
  }
  bibtex <- lapply(ref_sections,extract_dois)
  message("DOIs retrieved.")
  print(bibtex)
  # Rename shorthand/keys

  rename_doi_key <- function(dois) {
    dois <- unlist(dois)
    for (i in 1:length(dois)) {
      doi <- stringr::str_extract(dois[i], "DOI=\\{.+?\\}")
      doi <- gsub("DOI=\\{","",doi)
      doi <- gsub("\\}","",doi)
      dois[i] <- gsub("\\{.+, title=\\{", paste0("\\{",doi,", title=\\{"), dois[i])
    }
    dois <- as.list(dois)
  }
  bibtex <- lapply(bibtex,rename_doi_key)
  #rename_doi_key(unlist(t)[1],4)
  print(bibtex)

  # Create sections
  get_section_titles <- function(ref_sections) {
    ref_sections$title
  }
  ref_section_titles <- lapply(ref_sections,get_section_titles)

  if (merge_sections == FALSE) {
    sections <- c()
  } else {
    sections <- c("", paste0("# ", merged_title), "")
  }

  for (i in 1:length(ref_section_titles)) {

    get_shorthand <- function(DOI) { sub(", title=.*$", "", sub("^ @article\\{", "", DOI)) }

    if (merge_sections == FALSE) {
      sections <- c(sections, "", paste0("# ", unlist(ref_section_titles[i])), "","::: hide-me", paste0("@", get_shorthand(unlist(bibtex[i]))),":::", "")
    } else {
      sections <- c(sections, "::: hide-me", paste0("@", get_shorthand(unlist(bibtex[i]))),":::", "")
    }

  }

  # Create .bib file
  bib <- unlist(bibtex)
  bib <- stringr::str_replace_all(bib,"‐","-")
  writeLines(bib, paste0(getwd(), "/publistR_temp/references.bib"))

  #### CREATE .QMD FILE ####
  yaml_section <- readLines(paste0(getwd(), "/publistR_temp/yaml.txt"))
  qmd_file <- c("---",yaml_section, "---",sections)
  writeLines(qmd_file, paste0(getwd(), "/publistR.qmd"))

  #### KNIT .QMD FILE ####
  quarto::quarto_render(paste0(getwd(), "/publistR.qmd"))

  #### DELETE HELPER FILES ####
  file.remove("publistR.qmd")
  unlink("publistR_temp", recursive = TRUE)
}
