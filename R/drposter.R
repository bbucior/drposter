#' Generate academic posters in R Markdown based on 'reveal.js'
#'
#' Format for converting R Markdown reveal.js presentations to HTML/CSS posters.
#'
#' @inheritParams rmarkdown::html_document
#'
#' @param self_contained Whether or not the poster should be packaged into a
#'   a single self-contained file. Set to \code{FALSE} by default to save build time.
#' @param css One or more CSS files defining the poster styling. Some base
#'   styles in poster.css are copied by default into the current directory and
#'   automatically linked in the generated HTML unless this parameter is defined.
#' @param theme Currently unused.
#' @param template Pandoc template to use for rendering. Pass "poster" to use
#'   the modified reveal.js poster template built into this package; pass
#'   \code{NULL} to use pandoc's built-in template for reveal.js; pass a path
#'   to use a custom template that you've created. Note that if you don't use
#'   the default "poster" template then the reveal.js presentation javascript
#'   will load and transform your poster into a presentation with inconsistent
#'   styling.
#' @param ... Additional parameters to pass to revealjs; otherwise ignored.
#'
#' @return R Markdown output format to pass to \code{\link[rmarkdown]{render}}
#'
#' @details
#'
#' Use level 1 sections (`#`) to denote main divisions of content.
#' Assigning a `{.col-x}` class, where `x` is 1--3, will stretch the container
#' across the page width with `x` equal subcolumns, using Flexbox
#' The actual content goes inside of level 2 containers (`## Block title here`).
#' There are also a few convenience classes, such as formatting a QR code block.
#' The markdown source for the poster in \code{inst/example} perhaps provides the
#' best documentation by example.
#'
#' For additional documentation on using revealjs presentations see
#' \href{https://github.com/rstudio/revealjs}{https://github.com/rstudio/revealjs}.
#'
#' @examples
#' \dontrun{
#'
#' library(revealjs)
#' library(drposter)
#'
#' # simple invocation
#' rmarkdown::render("pres.Rmd", revealjs_poster())
#' }
#'
#' @export

revealjs_poster <- function(self_contained = FALSE,
                            template = "poster",
                            css = "poster.css",
                            theme = NULL,
                            ...) {
  # Generate a new output format using a template modified from pandoc
  # With help from http://rmarkdown.rstudio.com/developer_custom_formats.html
  if (identical(template, "poster")) {
    template_file <- system.file(
      "rmarkdown/templates/drposter/resources/default.html",
      package = "drposter"
    )
  } else if (!is.null(template)) {
    template_file <- template
  }

  # The rstudio documentation is quite good: https://rmarkdown.rstudio.com/html_document_format.html
  rmarkdown::html_document(
    template = template_file,
    self_contained = self_contained,
    css = css,
    section_divs = TRUE,  # Set up the nesting div structure for the poster
    theme = NULL,  # themes not supported now but may be added later
    ...
    )
}
