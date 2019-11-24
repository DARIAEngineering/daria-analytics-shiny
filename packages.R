# Shiny is implied thanks to our Docker image
pkgs = c(
  'highcharter',
  'dplyr'
)

install.packages(pkgs, quiet=TRUE)
