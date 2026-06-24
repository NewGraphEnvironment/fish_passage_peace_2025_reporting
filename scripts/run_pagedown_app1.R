# Build the standalone Phase 1 attachment PDF: docs/Appendix_1.pdf
#
# The print report (run_pagedown.R) carries only a slim link-stub (2300-...)
# for the Phase 1 data+photos; that stub links to docs/Appendix_1.pdf. This
# script renders ONLY the inline Phase 1 appendix (0835-...) to a paged PDF,
# crops the report front-matter pages, and ghostscript-compresses the result
# so it stays small enough to commit.
#
# Run only when the Phase 1 data or photos change.
#
# Split out of the legacy monolithic scripts/run.R (now removed) block 3. Two things to verify on a
# real run (flagged because they're report-specific and the old block predates
# the 0835 appendix structure):
#   1. Keep-set is `index|0835` — if 0835's tables/photos are built in a data-
#      prep chunk that lives in another chapter, that chapter must stay in the
#      build or 0835 will error on missing objects.
#   2. `crop_this_many_pages` (front-matter pages to drop) may need adjusting
#      if the front matter page count changes.
#
# Usage:
#   Rscript scripts/run_pagedown_app1.R

options(repos = c(CRAN = "https://cloud.r-project.org"))

toggle_gitbook_on <- function(value) {
  txt <- readLines("index.Rmd")
  i <- grep("^gitbook_on <- (TRUE|FALSE)\\s*$", txt)
  if (length(i) == 0) stop("gitbook_on toggle line not found in index.Rmd")
  txt[i[1]] <- sprintf("gitbook_on <- %s", value)
  writeLines(txt, "index.Rmd")
}

build_appendix1 <- function() {
  on.exit(toggle_gitbook_on("TRUE"), add = TRUE)
  toggle_gitbook_on("FALSE")

  staticimports::import()
  source('scripts/staticimports.R')

  yml             <- yaml::read_yaml("_bookdown.yml")
  input_html_stem <- yml$book_filename
  input_html      <- paste0(input_html_stem, ".html")

  # PDF render-time globals (same as run_pagedown.R) so chunks resolve them
  # via lazy defaults; render with envir = globalenv() below.
  font_set    <<- 9
  photo_width <<- "80%"
  gitbook_on  <<- FALSE

  # --- Keep only index + the inline Phase 1 appendix (0835); hold the rest --
  keep_pattern  <- "index|0835-appendix-phase1-data-photos"
  files_to_move <- list.files(pattern = "\\.Rmd$") |>
    stringr::str_subset(keep_pattern, negate = TRUE)
  files_destination <- file.path("hold", files_to_move)

  cat("\n=== Moving non-appendix Rmds to hold/ ===\n")
  for (i in seq_along(files_to_move)) {
    hold_path <- file.path("hold", basename(files_to_move[i]))
    if (file.exists(hold_path)) file.remove(hold_path)
    ok <- file.rename(files_to_move[i], hold_path)
    cat(sprintf("  %s -> %s : %s\n", files_to_move[i], hold_path, ok))
  }

  restore_rmds <- function() {
    for (i in seq_along(files_destination)) {
      if (!file.exists(files_destination[i])) next
      if (file.exists(files_to_move[i])) file.remove(files_to_move[i])
      file.rename(files_destination[i], files_to_move[i])
    }
  }
  # Crash-safe restore so a failed render doesn't strand chapters in hold/
  on.exit(restore_rmds(), add = TRUE)

  # --- Render the Phase 1-only paged HTML ----------------------------------
  bookdown::render_book(
    input         = "index.Rmd",
    output_format = "pagedown::html_paged",
    encoding      = "UTF-8",
    envir         = globalenv()
  )

  cat("\n=== Restoring chapters from hold/ ===\n")
  restore_rmds()

  # --- Print to PDF, crop front matter, compress ---------------------------
  cat(sprintf("\nPrinting %s -> docs/Appendix_1_prep.pdf ...\n", input_html))
  pagedown::chrome_print(input_html, output = "docs/Appendix_1_prep.pdf", timeout = 120)

  n_pages <- pdftools::pdf_length("docs/Appendix_1_prep.pdf")
  crop_this_many_pages <- 8   # report front-matter pages to drop; verify per build
  pdftools::pdf_subset(
    "docs/Appendix_1_prep.pdf",
    pages  = (crop_this_many_pages + 1):(n_pages - 1),   # also drops trailing references page
    output = "docs/Appendix_1.pdf"
  )

  file.remove("docs/Appendix_1_prep.pdf")
  if (file.exists(input_html)) file.remove(input_html)

  # Shrink so we don't bloat the repo.
  tools::compactPDF(
    "docs/Appendix_1.pdf",
    gs_quality = 'ebook',
    gs_cmd     = "/opt/homebrew/bin/gs",
    verbose    = TRUE
  )

  cat(sprintf("\nAppendix_1.pdf size: %.1f MB\n", file.size("docs/Appendix_1.pdf") / 1024^2))
}
build_appendix1()
