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

  # add author names
  yaml_data[["bold-auth-name"]] <- namelist

  # fix the citeproc value
  verbatim_logical <- yaml::verbatim_logical
  yaml_data <- yaml::as.yaml(yaml_data, handlers = list(logical=verbatim_logical))

  # Write the modified YAML to a new file in the temp directory
  output_path <- paste0(getwd(), "/publistR_temp/yaml.txt")
  writeLines(yaml_data, output_path)
}
