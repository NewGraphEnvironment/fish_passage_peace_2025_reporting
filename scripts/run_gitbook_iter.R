# Fast gitbook-only build for iterating on report content.
#
# Mirrors `scripts/run.R` block 1 but trimmed to gitbook only (no PDF) +
# auto-open at the end. Use this when iterating on Rmd content and you
# want a quick render to inspect. When verifying full ship readiness
# (both gitbook + pagedown PDF + Phase 1 appendix subset), use
# `scripts/run.R` instead.
#
# Assumes `gitbook_on <- TRUE` is set in index.Rmd (default state).
#
# Usage:
#   source('scripts/run_gitbook_iter.R')

# Rscript doesn't inherit RStudio's CRAN-mirror setting; set explicitly so
# scripts/packages.R `available.packages()` calls don't error.
options(repos = c(CRAN = "https://cloud.r-project.org"))

staticimports::import()
source('scripts/staticimports.R')

# Move heavy appendices out of build (mirrors run.R block 1)
files_to_move     <- list.files(pattern = ".Rmd$") |>
  stringr::str_subset('0600|2300', negate = FALSE)
files_destination <- paste0('hold/', files_to_move)
mapply(file.rename, from = files_to_move, to = files_destination)

# Hide pre-existing phase 1 appendix HTML (rebuilt separately via run.R block 3)
if (file.exists("docs/appendix---phase-1-fish-passage-assessment-data-and-photos.html")) {
  file.rename(
    "docs/appendix---phase-1-fish-passage-assessment-data-and-photos.html",
    "hold/appendix---phase-1-fish-passage-assessment-data-and-photos.html"
  )
}

fs::file_copy(
  'hold/0600-appendix-placeholder.Rmd',
  '0600-appendix-placeholder.Rmd',
  overwrite = TRUE
)

# Build
rmarkdown::render_site(output_format = 'bookdown::gitbook', encoding = 'UTF-8')

# Restore moved files
mapply(file.rename, from = files_destination, to = files_to_move)
if (file.exists("hold/appendix---phase-1-fish-passage-assessment-data-and-photos.html")) {
  fs::file_copy(
    "hold/appendix---phase-1-fish-passage-assessment-data-and-photos.html",
    "docs/appendix---phase-1-fish-passage-assessment-data-and-photos.html",
    overwrite = TRUE
  )
}
file.rename('0600-appendix-placeholder.Rmd', 'hold/0600-appendix-placeholder.Rmd')

# Auto-open results chapter (or fall back to index.html)
results_html <- list.files("docs", pattern = "^results", ignore.case = TRUE, full.names = TRUE)[1]
if (is.na(results_html)) results_html <- "docs/index.html"
if (file.exists(results_html)) system(paste("open", shQuote(results_html)))
