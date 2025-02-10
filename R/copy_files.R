#' copy_files
#'
#' @name copy_files
#' @rdname copy_files
#' @author Zheer Kejlberg Al-Mashhadi
#' @description INTERNAL
#' @keywords internal
#' @usage NULL
#' @export

#### copy_files(): Internal

copy_files <- function() {
  # get filepaths
  csl_path <- system.file("publistR.csl", package = "publistR")
  font_doc_path <- system.file("font-ref-doc.docx", package = "publistR")
  section_bibliographies_path <- system.file("section-bibliographies.lua", package = "publistR")

  # location to copy to
  to_path <- paste0(getwd(), "/publistR_temp")

  # create temp directory
  dir.create(paste0(getwd(), "/publistR_temp"))

  # copy files
  file.copy(csl_path, to_path)
  file.copy(font_doc_path, to_path)
  file.copy(section_bibliographies_path, to_path)
}
