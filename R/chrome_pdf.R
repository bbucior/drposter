#' Convert HTML to PDF using Chrome
#'
#' Calls headless Chrome to export an HTML document to a PDF poster automatically
#' without needing to manually open up the web browser and "print" the document.
#'
#' @param html_path .htm/.html document to export
#' @param pdf_path Path to write the exported PDF document.  By default, drposter will
#'   strip the .html extension and write a .pdf file
#' @param temp_dir Location of the temporary user profile directory for headless Chrome.
#'   If you run into problems, the `decapitated` package suggests that a subdirectory of
#'   the user's home (e.g. ~/temp_drposter) may work better
#' @param browser_bin Path to run Google Chrome.  If unspecified, drposter will
#'   automatically search common installation paths for your current OS.
#' @param timeout Number of seconds before cancelling document generation.
#'   Use a larger value if the document needs longer to build for some reason.
#'   Inspired by the flag from rstudio/pagedown:chrome.R.
#' @param echo_cmd Whether to print the Chrome command line to the screen
#'
#' @details
#'
#' Use Chrome/Chromium to convert an HTML document (e.g. drposter HTML output) to PDF.
#' A temporary profile directory is required to launch headless Chrome as a separate
#' instance than any currently open windows, else the command line flags will not
#' take effect.
#'
#' This implementation uses code from the pagedown, decapitated, and xfun packages.
#'
#' @references
#' \url{https://developers.google.com/web/updates/2017/04/headless-chrome}
#' \url{https://askubuntu.com/questions/35392/how-to-launch-a-new-instance-of-google-chrome-from-the-command-line}
#' \url{https://github.com/rstudio/pagedown/blob/master/R/chrome.R}
#' \url{https://www.rdocumentation.org/packages/decapitated/versions/0.3.0}
#'
#' @export

chrome_pdf <- function(
  html_path, pdf_path = NULL,
  temp_dir = tempfile(), browser_bin = NULL,
  timeout = 10, echo_cmd = TRUE
  ) {
  # Set up Chrome path, per rstudio/pagedown::chrome_print()
  if (missing(browser_bin)) {
    browser_bin <- find_chrome()
  } else {
    if (!file.exists(browser_bin)) browser_bin = Sys.which(browser_bin)
  }
  if (!utils::file_test('-x', browser_bin)) stop('The browser is not executable: ', browser_bin)
  # Check the file extension of the HTML input
  is_html = function(x) grepl('[.]html?$', x)
  if (!is_html(html_path)) stop(
    "The file '", html_path, "' should have the '.html' or '.htm' extension."
  )

  if (!file.exists(html_path)) {
    stop("The input file '", html_path, "' does not exist.")
  }

  # Need to use absolute paths on Windows or Chrome will have trouble finding the files
  html_path <- normalizePath(html_path)

  # Also set up the temporary directory
  # check that work_dir does not exist because it will be deleted at the end
  if (dir.exists(temp_dir)) stop('The directory ', temp_dir, ' already exists.')
  temp_dir = normalizePath(temp_dir, mustWork = FALSE)
  on.exit(unlink(temp_dir, recursive = TRUE), add = TRUE)

  if (is.null(pdf_path)) {
    base_html_name <- tools::file_path_sans_ext(html_path)
    pdf_path <- paste0(base_html_name, ".pdf")
  }
  pdf_path <- normalizePath(pdf_path, mustWork = FALSE)

  # Run Chrome headless, adapted from decapitated::chrome_dump_pdf()
  args <- c("--headless")
  # Apparently, both decapitated and pagedown disable the sandbox for Windows
  xfun_is_windows <- function() .Platform$OS.type == 'windows'
  if (xfun_is_windows()) args <- c(args, '--no-sandbox')
  args <- c(args, "--no-first-run", "--no-default-browser-check", "--hide-scrollbars")
  # Incorporate other useful command args from the decapitated package
  args <- c(args, "--disable-gpu")
  args <- c(args, sprintf("--user-data-dir=%s", temp_dir))
  args <- c(args, sprintf("--crash-dumps-dir=%s", temp_dir))
  args <- c(args, sprintf("--utility-allowed-dir=%s", temp_dir))
  # Add a flag to avoid font issues, per my Makefile:
  # Use the virtual time parameter to avoid FOIT issues (diagnosed by changing the font-display properties), since headless Chrome is deeming the page loaded before all the fonts have caught up.
  # The parameter gives the page more time (ms) to load before it's considered ready and "in a consistent-ish state": <https://groups.google.com/a/chromium.org/forum/#!topic/headless-dev/honibIZeYz0>
  # Waiting for page load is a [difficult problem](https://github.com/GoogleChrome/puppeteer/issues/338) and known issue in scripted/headless Chrome.
  # In part, the difficulty arises from Chrome trying to [print as soon as the page is ready](https://github.com/chromium/chromium/blob/0fb6097de7a555a77a69f8e239f98f938c72c2f8/headless/app/headless_shell.cc).
  # For more background, see also [headless Chrome documentation](https://developers.google.com/web/updates/2017/04/headless-chrome) and a [list of Chromium command line switches](https://peter.sh/experiments/chromium-command-line-switches/).
  args <- c(args, sprintf("--virtual-time-budget=%s", 10000))

  args <- c(args, sprintf("--print-to-pdf=%s", pdf_path))
  args <- c(args, html_path)

  # Define a callback function to detect errors in format conversion, e.g. FILE_ERROR_IN_USE
  # For more information, see https://processx.r-lib.org/#callbacks-for-io
  error_detection <- function(line, proc) {
    if (grepl(":ERROR:headless_shell.cc", line, fixed=TRUE)) {
      proc$kill()
      #stop(line)  # Let's do this after processx::run, instead.
      # I was intermittently encountering R crashes.  My best guess was a timing issue/race between the end
      # of the callback function and the parent chrome_pdf function.  There haven't been any crashes since
      # I consolidated `stop` to run at the end of chrome_pdf, so hopefully this change fixes the crashing.
    }
  }

  if (echo_cmd) {
    message(paste("Running Chrome with a timeout of", timeout, "seconds"))
  }
  processx::run(
    command = browser_bin,
    args = args,
    error_on_status = FALSE,
    echo_cmd = echo_cmd,
    echo = FALSE,
    timeout = timeout,
    stderr_line_callback = error_detection  # the callback might not run immediately, but it's soon enough
  ) -> res

  if (res$status != 0 | res$timeout) {
    stop(paste0("Crash or timeout from Chrome\n", res$stderr))
  }

  invisible(pdf_path)
}


#' Find Google Chrome or Chromium in the system
#'
#' On Windows, this function tries to find Chrome from the registry. On macOS,
#' it returns a hard-coded path of Chrome under \file{/Applications}. On Linux,
#' it searches for \command{chromium-browser} and \command{google-chrome} from
#' the system's \var{PATH} variable.
#'
#' Copied from rstudio/pagedown:chrome.R (MIT licensed) with a minor tweak to
#' remove the dependency on xfun (using yihui/xfun/os.R)
#' @return A character string.
#' @export
find_chrome = function() {
  xfun_is_macos = function() unname(Sys.info()['sysname'] == 'Darwin')
  switch(
    .Platform$OS.type,
    windows = {
      res = tryCatch({
        unlist(utils::readRegistry('ChromeHTML\\shell\\open\\command', 'HCR'))
      }, error = function(e) '')
      res = unlist(strsplit(res, '"'))
      res = utils::head(res[file.exists(res)], 1)
      if (length(res) != 1) stop(
        'Cannot find Google Chrome automatically from the Windows Registry Hive. ',
        "Please pass the full path of chrome.exe to the 'browser' argument."
      )
      res
    },
    unix = if (xfun_is_macos()) {
      '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
    } else {
      # Added 'chromium' as a valid command
      for (i in c('chromium-browser', 'google-chrome', 'chromium')) {
        if ((res <- Sys.which(i)) != '') break
      }
      if (res == '') stop('Cannot find chromium-browser, chromium, or google-chrome')
      res
    },
    stop('Your platform is not supported')
  )
}

