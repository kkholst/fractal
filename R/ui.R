##' User-interface for visualizing fractals
##' @export
##' @param ... additional arguments to lower level functions
##' @examples
##' if (interactive()) fractalr::ui()
ui <- function(...) {
    appDir <- system.file("shiny", package = "fractalr")
    if (appDir == "") {
        stop("Could not find example directory. Try re-installing `fractalr`.", call. = FALSE)
    }
    shiny::runApp(appDir, display.mode = "normal")
}
