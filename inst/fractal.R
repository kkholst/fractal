## http://paulbourke.net/fractals/juliaset/
## https://en.wikipedia.org/wiki/Cantor_set
## https://en.wikipedia.org/wiki/Mandelbrot_set#Generalizations
## https://en.wikipedia.org/wiki/Multibrot_set
## https://kukuruku.co/post/julia-set/

devtools::load_all("..")
library('viridis')

c <- 0.355534 - 0.337292i
K <- 1000
cols = viridis::inferno(K,direction=-1)
R <- 1.5
res <- .julia(c, R=R, 1000, maxIter=K)
with(res, image(x, y, z, useRaster=TRUE, col=cols))
while (TRUE) {
    xy <- locator(1)
    if (is.null(xy)) break
    R <- R*0.25
    res <- .julia(c, R=R, cx=xy[[1]], cy=xy[[2]], 1000, maxIter=K)
    image(res, useRaster=TRUE, col=cols)
}


K <- 100
cols = viridis::inferno(K,direction=-1)
dim <- 1000
R <- 1.5
res <- .mandelbrot(R=R, dim, maxIter=K, cx=-.75)
with(res, image(x, y, z, useRaster=TRUE, col=cols))
while (TRUE) {
    xy <- locator(1)
    if (is.null(xy)) break
    R <- R*0.25
    res <- .mandelbrot(R=R, cx=xy[[1]], cy=xy[[2]], dim, maxIter=K)
    image(res, useRaster=TRUE, col=cols)
}


K <- 48
cols = viridis::inferno(K,direction=-1)
dim <- 800
R <- 1.5
exponent <- 1.5
res <- .mandelbrot(exponent=exponent, R=R, d=dim, maxIter=K, cx=0)
with(res, image(x, y, z, useRaster=TRUE, col=cols))
while (TRUE) {
    xy <- locator(1)
    if (is.null(xy)) break
    R <- R*0.25
    res <- .mandelbrot(exponent=exponent, R=R, cx=xy[[1]], cy=xy[[2]], dim, maxIter=K)
    image(res, useRaster=TRUE, col=cols)
}
