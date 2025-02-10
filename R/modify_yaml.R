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
  #yaml_path <- "inst/yaml.yaml"
  yaml_data <- yaml::yaml.load_file(yaml_path)

  yaml_data[["bold-auth-name"]] <- namelist

  # Write the modified YAML to a new file in the temp directory
  output_path <- file.path(getwd(), "/publistR_temp/yaml.yaml")
  yaml::write_yaml(yaml_data, output_path)
}
