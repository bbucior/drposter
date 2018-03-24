#' Update drposter template
#'
#' Update supporting files for drposter template in the directory drposter_files/
#' using a newer version from the installed package.  This function does not update your
#' installed version of the drposter package, just the locally cached template files.
#'
#' @param verbose Prints backup and package directories to the console
#'
#' @details
#'
#' Copies relevant drposter resources from the rmarkdown skeleton into the local copy
#' in drposter_files/.  Makes a backup by default to a directory including the current
#' datetime, unless drposter_files/ does not exist.  Previous versions attempted to
#' make the lib_dir and backup_dir configurable, but they came across compatibility issues
#' with the cached rmarkdown workflow and/or R's file.rename/copy commands.
#'
#' @export

drposter_update <- function(verbose = TRUE) {
  # Update the drposter template, inspired by how rstudio/revealjs handles the JS resources.
  lib_dir = "drposter_files/"

  if (length(list.dirs(lib_dir))) {  # Only make a backup if lib_dir already exists
    backup_dir <- sub(" ", "T", as.character(Sys.time()), fixed=TRUE)
    backup_dir <- gsub(":", "-", backup_dir, fixed=TRUE)
    backup_dir <- paste0("backup-drposter-", backup_dir)

    file.rename(lib_dir, backup_dir)
    if (verbose) cat(paste("Generated a backup in", backup_dir, "\n"))
  }

  # Find installed drposter resources and overwrite lib_dir
  drposter_path <- system.file(
    "rmarkdown/templates/drposter/skeleton/drposter_files",
    package="drposter"
    )
  rmarkdown::render_supporting_files(drposter_path, ".")
  if (verbose) cat(paste("Updated drposter package files into", lib_dir, "\n"))
  invisible(NULL)
}
