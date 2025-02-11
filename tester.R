#install.packages("rcrossref")
library(rcrossref)
library(yaml)

add_author_name(family = "Kejlberg Al-Mashhadi", given = "Zheer")
add_author_name(family = "Kejlberg", given = "Zheer")
add_author_name(family = "Al-Mashhadi", given = "Zheer")

dois <- c("10.21926/obm.geriatr.2002123",
  "https://doi.org/10.1016/j.jacc.2019.06.057",
  "https://doi.org/10.1016/j.jacc.2019.07.009")


doi_sections <- list(
  list(title = "First", DOIs = c("10.21926/obm.geriatr.2002123","https://doi.org/10.1016/j.jacc.2019.06.057")),
  list(title = "Second", DOIs = c("https://doi.org/10.1016/j.jacc.2019.06.057","https://doi.org/10.1016/j.jacc.2019.07.009"))
)

rcrossref::cr_cn(DOIs)

extract_dois <- function(doi_lists) {
  rcrossref::cr_cn(doi_lists$DOIs)
}



ttt <- lapply(doi_sections,extract_dois)
ttt
ttt2 <- unlist(ttt)

get_section_titles <- function(doi_lists) {
  doi_lists$title
}
rrr <- lapply(doi_sections,get_section_titles)

p <- c()
for (i in 1:length(rrr)) {
  p <- c(p, unlist(rrr[i]), unlist(ttt[i]))
}

p

rcrossref::cr_cn(dois)

publistR_section("WoW", dois)


qmd_file <- readLines(paste0(getwd(), "/inst/yaml.yaml"))
qmd_file <- c(qmd_file, sections)
outpath <- paste0(getwd(), "/publistR.qmd")
writeLines(qmd_file, paste0(getwd(), "/publistR.qmd"))

t <- readLines(paste0(getwd(), "/inst/yaml.yaml"))
t <- c(t,
       z)
t
writeLines(t, paste0(getwd(), "/inst/yaml2.yaml"))
print(t)
