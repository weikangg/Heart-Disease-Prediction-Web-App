my_packages = c("markdown", "shiny", "shinythemes", "data.table", "RCurl", "tidyverse", "cvms", "caTools", "tibble")

install_if_missing = function(p) {
  if (p %in% rownames(installed.packages()) == FALSE) {
    install.packages(p)
  }
}

invisible(sapply(my_packages, install_if_missing))