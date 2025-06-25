# {publistR}
Zheer Kejlberg Al-Mashhadi

## Welcome to {publistR}

An R package to easily turn your bibliography or a list of DOIs into a
structured and formatted list of publications.

## Installation

``` r
devtools::install_github("zheer-kejlberg/publistR")
library(publistR)
```

And you’re good to go

## Usage

First try out

``` r
?publistR
```

the documentation should help you get started quickly.

The package consists of one function, aptly named publistR() which has
two required input arguments:

1)  `author_names`

2)  `ref_sections`

### Bold font author names

the `author_names` argument takes a list of named lists as input. Each
internal list represents an author name to be highlighted. E.g.;

``` r
author_names = list(
  list(family = "Al-Mashhadi", given = "Zheer"),
  list(family = "Al-Mashhadi", given = "Zheer Kejlberg")
  )
```

### Sections

the `ref_sections` argument takes a list of named lists as input. Each
internal list represents an section in the final document. Each section
requires a title (a single string) and a vector of DOIs. E.g.;

``` r
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
  )
```

### Using .bib file instead of (or in addition to) DOIs

the `bib_file` argument allows you to specify a .bib filepath which will
be used to any input supplied to `ref_sections` that doesn’t have a
DOI-format. The input will then be assumed to be a reference key in the
.bib-file.

E.g.:

``` r
publistR(
  author_names = list(
    list(family = "Al-Mashhadi", given = "Z."),
    list(family = "Al-Mashhadi", given = "Z. K.")
  ),
  ref_sections = list(
    list(title = "Manuscripts", 
         DOIs = c("https://doi.org/10.3389/fendo.2022.882998",
                  "al-mashhadi2022"
         ))
  ),
  bib_file = "references.bib"
)
```

### Other

The remaining arguments are optional. They provide the option to change
the input and output paths, the format (.pdf, .html, .docx), to provide
your own custom .csl (citation style language) file, your own custom
Word Font Template file, and more.

Enjoy.

## Acknowledgements

This package draws on open source work by the following:

Brenton Wiernik’s APA .csl:
https://github.com/citation-style-language/styles/blob/master/apa-cv.csl

Shafee’s bold-author.lua file from the following SO thread:
https://stackoverflow.com/questions/76394078/format-specific-authors-with-bold-font-in-bibliography-created-with-quarto/76429867#76429867

Matt Capaldi’s hide-me.lua file

Jesse Rosenthal and Albert Krewinkel’s section-bibliographies.lua
