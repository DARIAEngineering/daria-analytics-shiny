# Shiny is implied thanks to our Docker image
# So are the tidyverse suite of packages - https://www.tidyverse.org/packages/
pkgs = c(
  'highcharter'
)

install.packages(pkgs, quiet=TRUE)
