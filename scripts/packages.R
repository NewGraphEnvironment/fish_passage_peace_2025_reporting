# ensure pak is installed
# Removed update check that breaks non-interactive builds - see #150
if (!requireNamespace("pak", quietly = TRUE)) {
  install.packages("pak", repos = "https://cloud.r-project.org")
}

pkgs_cran <- c(
  'tidyverse',
  'knitr',
  'bookdown',
  'rmarkdown',
  'pagedown',
  'RPostgres',
  'sf',
  # removed ggdark - see #149
  "kableExtra",
  "english",
  "pdftools"
)

pkgs_gh <- c(
  "newgraphenvironment/fpr",
  "newgraphenvironment/ngr",
  "newgraphenvironment/staticimports",
  "lucy-schick/fishbc@updated_data",
  "poissonconsulting/readwritesqlite", #https://github.com/poissonconsulting/readwritesqlite/issues/47
  "paleolimbot/rbbt"
)

pkgs_all <- c(pkgs_cran,
              pkgs_gh)


# install or upgrade all the packages with pak
# install or upgrade all the packages with pak
if(params$update_packages){
  lapply(pkgs_all, pak::pkg_install, ask = FALSE)
}

# load all the packages
# Strip @branch suffix before basename - see #150
pkgs_ld <- c(pkgs_cran,
             basename(pkgs_gh) |> stringr::str_remove("@.*"))

lapply(pkgs_ld,
       require,
       character.only = TRUE)
