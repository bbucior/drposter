#' Generate academic posters in R Markdown and CSS
#'
#' R Markdown (pandoc) format for generating HTML/CSS posters, inspired by reveal.js
#'
#' @inheritParams rmarkdown::html_document
#'
#' @param self_contained Whether or not the poster should be packaged into a
#'   a single self-contained file. Set to \code{FALSE} by default to save build time.
#' @param css One or more CSS files defining the poster styling. Some base
#'   styles in poster.css are copied by default into the current directory and
#'   automatically linked in the generated HTML unless this parameter is defined.
#' @param pandoc_args Additional command line options to pass to pandoc
#' @param theme Currently unused.
#' @param fill_page Can optionally stretch the page content (by distributing
#'   whitespace between blocks) to span the entire height assigned to the poster.
#'   By default this is set to \code{FALSE}, which places content without extra spacing.
#' @param template Pandoc template to use for rendering. Pass \code{NULL} to use
#'   the HTML poster template built into this package.  You can also pass a path
#'   to a custom pandoc template that you've created.
#' @param ... Additional parameters to pass to html_document; otherwise ignored.
#'
#' @return R Markdown output format to pass to \code{\link[rmarkdown]{render}}
#'
#' @details
#'
#' Use level 1 sections (`#`) to denote main divisions of content.
#' Assigning a `{.col-x}` class, where `x` is 1--4, will stretch the container
#' across the page width with `x` equal subcolumns, using CSS Grid.
#' The actual content goes inside of level 2 containers (`## Block title here`).
#' Placing multiple level 2 containers within a level 1 section will distribute
#' their heights to match adjacent sections in the row, allowing for multicolumn
#' layouts (e.g. a standard 3-column academic poster).
#' There are also a few convenience classes, such as formatting a QR code block.
#' The markdown source for the poster in \code{inst/example} perhaps provides the
#' best documentation by example.
#'
#' The overall layout is inspired by markdown for slide presentations in reveal.js.
#' For additional documentation on using revealjs presentations see
#' \href{https://github.com/rstudio/revealjs}{https://github.com/rstudio/revealjs}.
#'
#' @examples
#' \dontrun{
#'
#' library(drposter)
#'
#' # simple invocation
#' rmarkdown::render("pres.Rmd", drposter_poster())
#' }
#'
#' @export

drposter_poster <- function(self_contained = FALSE,
                            template = NULL,
                            css = "poster.css",
                            pandoc_args = NULL,
                            theme = NULL,
                            fill_page = FALSE,
                            ...) {
  # Generate a new output format using a template modified from pandoc
  # With help from http://rmarkdown.rstudio.com/developer_custom_formats.html
  if (is.null(template)) {
    template_file <- system.file(
      "rmarkdown/templates/drposter/resources/default.html",
      package = "drposter"
    )
  } else {
    template_file <- template
  }

  args <- c()
  if (!is.null(fill_page)) {
    if (!fill_page) {
      fill_page = ""  # pandoc uses a different boolean notation (empty strings) than R
    }
    args <- c(args, "--variable", paste0("fill_page=", fill_page))
  }
  if (!is.null(pandoc_args)) {
    args <- c(args, pandoc_args)
  }

  # The rstudio documentation is quite good: https://rmarkdown.rstudio.com/html_document_format.html
  rmarkdown::html_document(
    template = template_file,
    self_contained = self_contained,
    css = css,
    pandoc_args = args,
    section_divs = TRUE,  # Set up the nested div structure for the poster
    theme = NULL,  # themes not supported now but may be added later
    ...
    )
}
