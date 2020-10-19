cols <- function(x,n=256) {
  # Default:
  color.palette <- ## YellowBrown
    gray.colors
  x <- tolower(x)
  if (x=="gray") {
    color.palette <- ## Gray
      gray.colors
  }
  if (x=="bo") {
    BlueOrangeBlue <- c("darkblue","blue","yellow","orange","darkblue","darkblue")
                                        #color.palette = colorRampPalette(BlueOrange, space = "Lab")
    color.palette = colorRampPalette(BlueOrangeBlue)
  }
  if (x=="brown") {
    color.palette <- ## Yellow-Brown
      colorRampPalette(c("#FFFFD4", "#FED98E", "#FE9929", "#D95F0E", "#993404"),
                       space = "Lab", bias = 0.5)
  }
  if (x=="jet") {
    color.palette <- ## Jet-colors (matlab)
      colorRampPalette(c("#00007F", "blue", "#007FFF", "cyan",
                         "#7FFF7F", "yellow", "#FF7F00", "red", "#7F0000"))
  }
  if (x=="usa") { ## Red-White-Blue
    color.palette <- colorRampPalette(c("red", "white", "blue"))
  }
  if (x=="rob") { ## Red-Orange-Bue
    color.palette <- colorRampPalette(c("red", "orange", "blue"),
                                      space = "rgb")
  }
  mypalette <- color.palette(n)
  return(mypalette)
}
