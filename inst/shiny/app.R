
presets <- list(
    'None'=list(),
    'Julia 1'=list(type="Julia", c=complex(1,0.355,-0.355), R=2, x=0, y=0),
    'Julia 2'=list(type="Julia", c=complex(1,-.79,.15), R=2, x=0, y=0),
    'Mandelbrot 1'=list(type="Mandelbrot", R=1.5, x=-.75, y=0),
    'Whirlpool'=list(type="Mandelbrot", x=0.28610948214542825, y=0.46030998057392386, R=1e-6),
    'Seahorse valley'=list(type="Mandelbrot", x=-.75, y=0.1, R=1e-1),
    'Spiral'=list(type="Mandelbrot", x=-0.735635333333334, y=0.16922, R=1e-3))


ui <- fluidPage(
    sidebarLayout(
        mainPanel(
            plotOutput(outputId = "image1",
               width = "600px", height="600px",
               click = "img_click", dblclick = "img_dblclick"),
            splitLayout(
                numericInput("x_input", "x", value=NULL, width="100%"),
                numericInput("y_input", "y", value=NULL, width="100%"),
                numericInput("R_input", "R", value=NULL, width="100%")),
            splitLayout(
                numericInput("c_re_input", "Re(c)", value=0.355, width="50%"),
                numericInput("c_im_input", "Im(c)", value=-0.355, width="50%"))
            ),
        sidebarPanel(
            h3(textOutput("caption")),
            hr(),
            selectInput("presets", "Presets", choices=names(presets), selected=NULL),
            hr(),
            selectInput("color", "Color scheme",
                        choices=c("inferno", "plasma", "viridis",
                                  "heat", "topo", "rainbow")),
            sliderInput("maxIter", "Iterations", min=10, max=2000, value=1000),
            sliderInput("lambda", "Zoom factor", min=-10, max=10, value=4),
            p(textOutput("info")),
            radioButtons("type", "Fractal", choices=c("Mandelbrot", "Julia")),
            actionButton("button", "Update")
        ))
    )

server <- function(input, output, session) {
    output$caption <- renderText({ 'Options' })

    calculate <- function() {
        if (tolower(input$type)=="mandelbrot") {
            tt <- system.time(res <- fractalr:::.mandelbrot(cx=values$x, cy=values$y,
                                                dim=600, maxIter=input$maxIter,
                                                R=values$R))
        } else {
            cval <- complex(1,input$c_re_input, input$c_im_input)
            tt <- system.time(res <-  fractalr:::.julia(c=cval,
                                           cx=values$x, cy=values$y,
                                           dim=600, maxIter=input$maxIter,
                                           R=values$R))
        }
        ##print(tt)
        data(res)
    }

    updateSet <- reactive({
        updated <- FALSE
        lam <- input$lambda
        if (lam<0) {
            lam <- 1/(-lam+1)
        } else lam <- lam+1
        if (!is.null(input$img_click)) {
            if (values$x!=input$img_click$x || values$y!=input$img_click$y) {
                values[['x']] <- input$img_click$x
                values[['y']] <- input$img_click$y
                values[['R']] <- values$R/lam
                updated <- TRUE
            }
        }
        if (!is.null(input$img_dblclick)) {
            if (values$xx!=input$img_dblclick$x || values$yy!=input$img_dblclick$y) {
                values[['xx']] <- input$img_dblclick$x
                values[['yy']] <- input$img_dblclick$y
                values[['x']] <- values$xx
                values[['y']] <- values$yy
                values[['R']] <- values$R*lam
                updated <- TRUE
            }
        }
        updateNumericInput(session, "x_input", value=values[['x']])
        updateNumericInput(session, "y_input", value=values[['y']])
        updateNumericInput(session, "R_input", value=values[['R']])

        if (updated || is.null(data())) {
            calculate()
        }
        data()
    })

    data <- reactiveVal()
    values <- reactiveValues(x=-.75, y=0, xx=0, yyy=0, R=1.5, c=complex(1, 0.355,-0.355))

    observeEvent(input$presets, {
        if (input$presets!="None") {
            val <- presets[[input$presets]]
            updateRadioButtons(session, "type", selected=val$type)
            if (!is.null(val$x)) values[['x']] <- val$x
            if (!is.null(val$y)) values[['y']] <- val$y
            if (!is.null(val$R)) values[['R']] <- val$R
            if (!is.null(val$c)) values[['c']] <- val$c
            updateNumericInput(session, "c_re_input", value=Re(values[['c']]))
            updateNumericInput(session, "c_im_input", value=Im(values[['c']]))
        }
        calculate()
    })
    observeEvent(input$type, {
        calculate()
    })
    observeEvent(input$button, {
        values[['x']] <- input$x_input
        values[['y']] <- input$y_input
        values[['R']] <- input$R_input
        calculate()
    })
    observeEvent(input$c_re_input, {
        cval <- complex(1, input$c_re_input, input$c_im_input)
        values$c <- cval
        calculate()
    })
    observeEvent(input$c_im_input, {
        cval <- complex(1, input$c_re_input, input$c_im_input)
        values$c <- cval
        calculate()
    })

    output$image1 <- renderPlot({
        par(mar=c(0,0,0,0))
        res <- updateSet()
        cols <- switch(input$color,
                       inferno=viridis::inferno(256, direction=-1),
                       viridis=viridis::viridis(256, direction=-1),
                       plasma=viridis::plasma(256, direction=-1),
                       rainbow=rev(rainbow(256)),
                       heat=rev(heat.colors(256)),
                       topo=rev(topo.colors(256))
                       )
        image(res, useRaster=TRUE, axes=FALSE, col=cols)
        box()
    })
    output$info <- renderText({
        "Click graph to center and zoom in. Double click to zoom out."
    })
}

shinyApp(ui, server)
