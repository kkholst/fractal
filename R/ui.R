##' @export
ui <- function(...) {
    appDir <- system.file("shiny", package = "fractal")
    if (appDir == "") {
        stop("Could not find example directory. Try re-installing `fractal`.", call. = FALSE)
    }
    shiny::runApp(appDir, display.mode = "normal")
}
