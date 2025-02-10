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

publistR_knit <- function() {
  # Copy all files
  copy_files()

  # Modify YAML header
  modify_yaml()

  # Create references.bib
  create_bib()

  # Create .qmd file
  yaml_section <- readLines(paste0(getwd(), "/publistR_temp/yaml.yaml"))
  qmd_file <- c("---",yaml_section, "---",sections)
  writeLines(qmd_file, paste0(getwd(), "/publistR_temp/publistR.qmd"))

  # Knit .qmd file
  quarto::quarto_render(paste0(getwd(), "/publistR_temp/publistR.qmd"))
}
