#install.packages("rcrossref")
library(rcrossref)
library(yaml)

add_author_name(family = "Kejlberg Al-Mashhadi", given = "Zheer")
add_author_name(family = "Kejlberg", given = "Zheer")
add_author_name(family = "Al-Mashhadi", given = "Zheer")

dois <- c("10.21926/obm.geriatr.2002123",
  "https://doi.org/10.1016/j.jacc.2019.06.057",
  "https://doi.org/10.1016/j.jacc.2019.07.009")


publistR_section("WoW", dois)



t <- readLines(paste0(getwd(), "/inst/yaml.yaml"))
t <- c(t,
       z)
t
writeLines(t, paste0(getwd(), "/inst/yaml2.yaml"))
print(t)
