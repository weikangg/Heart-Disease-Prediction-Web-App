my_packages = c("data.table", "shiny", "shinythemes", "RCurl", "tidyverse", "cvms", "caTools", "tibble", "markdown", "shinyWidgets", "shinydashboard")

install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}

invisible(sapply(my_packages, install_if_missing))