

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' Draw limes
#'
#' @param mapping,data,stat,position,...,na.rm,show.legend,inherit.aes see
#'        documentation for \code{ggplot2::geom_point()}
#'
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
geom_lime <- function(mapping     = NULL,
                      data        = NULL,
                      stat        = "identity",
                      position    = "identity",
                      ...,
                      na.rm       = FALSE,
                      show.legend = NA,
                      inherit.aes = TRUE) {
  layer(
    data        = data,
    mapping     = mapping,
    stat        = stat,
    geom        = GeomLime,
    position    = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params      = list(
      na.rm    = na.rm,
      ...
    )
  )
}


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#' GeomPointZ
#'
#' @rdname ggplot2-ggproto
#' @format NULL
#' @usage NULL
#' @export
#' @import ggplot2
#' @import grid
#' @export
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
GeomLime <- ggplot2::ggproto(
  "GeomLime", ggplot2::Geom,
  required_aes = c("x", "y"),
  non_missing_aes = c("size"),
  default_aes = ggplot2::aes(
    shape  = 19,
    colour = "black",
    size   = 1.5,
    fill   = NA,
    alpha  = NA,
    stroke = 0.5
  ),

  draw_panel = function(data, panel_params, coord, na.rm = FALSE) {
    if (is.character(data$shape)) {
      data$shape <- translate_shape_string(data$shape)
    }

    coords <- coord$transform(data, panel_params)
    grid::pointsGrob(
      coords$x, coords$y,
      pch = coords$shape,
      gp = gpar(
        col  = ggplot2::alpha(coords$colour, coords$alpha),
        fill = ggplot2::alpha(coords$fill, coords$alpha),
        # Stroke is added around the outside of the point
        fontsize = coords$size * ggplot2::.pt + coords$stroke * ggplot2::.stroke / 2,
        lwd = coords$stroke * ggplot2::.stroke / 2
      )
    )

    lime_filename <- system.file("lime.png", package = "geomlime", mustWork = TRUE)
    im <- png::readPNG(lime_filename)

    grid::rasterGrob(
      image  = im,
      x      = coords$x,
      y      = coords$y,
      width  = ggplot2::unit(coords$size * 5          , 'pt'),
      height = ggplot2::unit(coords$size * 5 * 313/400, 'pt')
    )

  },

  draw_key = ggplot2::draw_key_point
)
