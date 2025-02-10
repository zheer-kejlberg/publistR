#' modify_yaml
#'
#' @name modify_yaml
#' @rdname modify_yaml
#' @author Zheer Kejlberg Al-Mashhadi
#' @description INTERNAL
#' @keywords internal
#' @usage NULL
#' @export

#### modify_yaml(): Internal

modify_yaml <- function() {
  # Read YAML file
  yaml_path <- system.file("yaml.yaml", package = "publistR")
  yaml_data <- yaml::yaml.load_file(yaml_path)

  # fix the citeproc value
  #yaml_data[["citeproc"]] <- "false"

  # add author names
  yaml_data[["bold-auth-name"]] <- namelist

  verbatim_logical <- yaml::verbatim_logical

  # Write the modified YAML to a new file in the temp directory
  output_path <- paste0(getwd(), "/publistR_temp/yaml.txt")
  #yaml::write_yaml(yaml_data, output_path)
  yaml_data <- yaml::as.yaml(yaml_data, handlers = list(logical=verbatim_logical))
  writeLines(yaml_data, output_path)
}
