% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/publistR.R
\name{publistR}
\alias{publistR}
\title{publistR}
\usage{
publistR(
         author_names,
         ref_sections,
         merge_sections = FALSE,
         merged_title,
         custom_fonts,
         title_bold = FALSE,
         title_italic = FALSE,
         title_underline = FALSE,
         title_small_caps = FALSE
       )
}
\arguments{
\item{author_names}{a list of lists containing author names to be highlighted. Each embedded list must have to keys "family =" and "given =" for sur- and firstname, respectively.}

\item{ref_sections}{a list of lists containing titles and DOIs for each section of the reference paper. Each embedded list must have two keys, "title =" and "DOIs =".}

\item{merge_sections}{a Boolean (defaults to FALSE) determining whether to merge all the supplied sections into one section with a common section title. For ease of use.}

\item{merged_title}{a section title for the merged section IF merge_sections is set to TRUE.}

\item{custom_fonts}{File path to a custom Quarto Word Template (for adjusting the output fonts). The fonts to set are Heading 1, Hyperlink and Body Text/First Paragraph. Arg defaults to 'NULL', using PublistR's internal Word Template.}

\item{title_bold}{Boolean, defaults to FALSE}

\item{title_italic}{Boolean, defaults to FALSE}

\item{title_underline}{Boolean, defaults to FALSE}

\item{title_small_caps}{Boolean, defaults to FALSE}
}
\description{
Create publication list
}
\examples{
  \dontrun{
  publistR(
    author_names = list(
      list(family = "Al-Mashhadi", given = "Zheer"),
      list(family = "Al-Mashhadi", given = "Zheer Kejlberg"),
      list(family = "Al-Mashhadi", given = "Z."),
      list(family = "Al-Mashhadi", given = "Z. K.")
    ),
    ref_sections = list(
      list(title = "First authorships",
           DOIs = c("https://doi.org/10.3389/fendo.2022.882998",
                    "https://doi.org/10.3389/fendo.2022.861422"
           )),
      list(title = "Co-authorships",
           DOIs = c("https://doi.org/10.1016/j.jacc.2020.11.059",
                    "https://doi.org/10.1016/j.jacc.2019.06.057",
                    "https://doi.org/10.3390/nu16193232",
                    "https://doi.org/10.1007/s12020-024-03789-1",
                    "https://doi.org/10.1111/dom.15220"
           ))
    ),
    title_bold = T
  )
  }
}
\author{
Zheer Kejlberg Al-Mashhadi
}
