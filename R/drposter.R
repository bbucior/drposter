#' Generate academic posters in R Markdown and CSS
#'
#' R Markdown (pandoc) format for generating HTML/CSS posters, inspired by reveal.js
#'
#' @inheritParams rmarkdown::html_document
#'
#' @param self_contained Whether or not the poster should be packaged into a
#'   a single self-contained file. Set to \code{FALSE} by default to save build time.
#' @param css One or more CSS files defining the poster styling. Some base
#'   styles in drposter.css are copied by default into a subdirectory and
#'   automatically linked in the generated HTML, in addition to custom styles
#'   specified by this parameter (e.g. custom.css).
#' @param pandoc_args Additional command line options to pass to pandoc
#' @param theme Currently unused.
#' @param fill_page Can optionally stretch the page content (by distributing
#'   whitespace between blocks) to span the entire height assigned to the poster.
#'   By default this is set to \code{FALSE}, which places content without extra spacing.
#' @param template Pandoc template to use for rendering. Pass \code{NULL} to use
#'   the default HTML poster template for this package, which is copied to the
#'   drposter_files subdirectory.  You can also pass a path to a custom pandoc
#'   template that you've created.
#' @param lib_dir Path to the pandoc HTML template and default CSS resource files
#'   for the poster. (or NULL to skip and manually specify them)  By default,
#'   rmarkdown will copy these files into the drposter_files/ subdirectory for a
#'   document, allowing easy optional updates to newer versions of the template.
#' @param export_pdf Run chrome_pdf to save a PDF poster in addition to the HTML version.
#'   WARNING: the PDF export post-processing hook is run before the default hook from
#'   rmarkdown::html_document_base, so the PDF output will NOT include "preserved chunks."
#'   (cases when you use htmltools::htmlPreserve to avoid Markdown parsing, e.g. a script tag)
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
                            css = "custom.css",
                            pandoc_args = NULL,
                            theme = NULL,
                            fill_page = FALSE,
                            lib_dir = "drposter_files/",
                            export_pdf = TRUE,
                            ...) {
  # Generate a new output format using a template modified from pandoc
  # With help from http://rmarkdown.rstudio.com/developer_custom_formats.html
  css_includes <- NULL
  template_file <- NULL
  if (!is.null(lib_dir)) {
    template_file <- file.path(lib_dir, "drposter.html", fsep="/")
  }
  # If specified, override the local template and CSS
  if (!is.null(template)) {
    template_file <- template
  }
  if (!is.null(css)) {
    css_includes <- c(css_includes, css)
  }

  args <- c()
  if (!is.null(fill_page)) {
    if (!fill_page) {
      fill_page = ""  # pandoc uses a different boolean notation (empty strings) than R
    }
    args <- c(args, "--variable", paste0("fill_page=", fill_page))
  }
  if (!is.null(lib_dir)) {
    args <- c(args, "--variable", paste0("lib_dir=", lib_dir))
  }
  if (!is.null(pandoc_args)) {
    args <- c(args, pandoc_args)
  }

  # The rstudio documentation is quite good: https://rmarkdown.rstudio.com/html_document_format.html
  dr_format <- rmarkdown::html_document(
    template = template_file,
    self_contained = self_contained,
    css = css_includes,
    pandoc_args = args,
    section_divs = TRUE,  # Set up the nested div structure for the poster
    theme = NULL,  # themes not supported now but may be added later
    ...
    )

  if (export_pdf) {
    # See also the source code of rstudio/rmarkdown::render, html_document[_base], output_format
    # for more details on adding post-processing hooks
    compile_pdf <- function(metadata, input_file, output_file, clean, verbose) {
      chrome_pdf(output_file, echo_cmd = verbose)
      output_file
      # Return the original .html output file, because the default RMarkdown HTML
      # post-processing hook runs after the PDF hook. (output_format prepends the PDF hook)
    }
    dr_format <- rmarkdown::output_format(
      # rmarkdown::output_format can inherit from a base_format and merge settings
      # together (such as adding a post_processor step).
      # Most flags are NULL by default, thus automatically derived from the base_format.
      # For the others, specify the known values for drposter or use a safe default.
      rmarkdown::knitr_options(),
      rmarkdown::pandoc_options(to = "html4"),
      keep_md = dr_format$keep_md,
      clean_supporting = dr_format$clean_supporting,
      # Inherit args and other settings from the drposter version of html_document above
      base_format = dr_format,
      # Add a PDF post-processing step to the existing format
      post_processor = compile_pdf
    )
  }

  dr_format
}
