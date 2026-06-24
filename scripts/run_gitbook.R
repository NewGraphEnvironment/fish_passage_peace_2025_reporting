# Build the gitbook (web) version of the report.
#
# Renders the full inline Phase 1 data+photos appendix (0835-...) along with
# the rest of the report, then auto-opens. The PDF link-stub (2300-...) stays
# in hold/ so it doesn't appear in the web version. For the print PDF use
# `scripts/run_pagedown.R`; to regenerate the standalone Phase 1 attachment
# PDF (docs/Appendix_1.pdf) use `scripts/run_pagedown_app1.R`.
#
# Assumes `gitbook_on <- TRUE` is set in index.Rmd (default state).
#
# Usage:
#   source('scripts/run_gitbook.R')

# Rscript doesn't inherit RStudio's CRAN-mirror setting; set explicitly so
# scripts/packages.R `available.packages()` calls don't error.
options(repos = c(CRAN = "https://cloud.r-project.org"))

staticimports::import()
source('scripts/staticimports.R')

# --- Defensive move helpers (report each rename outcome) ----------------
move_to_hold <- function(path) {
  if (!file.exists(path)) return(invisible(FALSE))
  hold_path <- file.path("hold", basename(path))
  if (file.exists(hold_path)) file.remove(hold_path)
  ok <- file.rename(path, hold_path)
  cat(sprintf("  %s -> %s : %s\n", path, hold_path, ok))
  invisible(ok)
}
move_back_from_hold <- function(path) {
  hold_path <- file.path("hold", basename(path))
  if (!file.exists(hold_path)) return(invisible(FALSE))
  if (file.exists(path)) file.remove(path)
  ok <- file.rename(hold_path, path)
  cat(sprintf("  %s -> %s : %s\n", hold_path, path, ok))
  invisible(ok)
}

# --- Ensure gitbook appendix layout: inline 0835 at root, stub 2300 hold -
# Resting state already matches this; we self-correct only if a crashed PDF
# build left the swap half-applied. The inline Phase 1 appendix (0835) renders
# its own gitbook chapter page (docs/appendix---phase-1-...html) that the PDF
# stub links to, so nothing needs stashing — the build regenerates it.
cat("\n=== Ensuring gitbook appendix layout (inline at root) ===\n")
move_back_from_hold("0835-appendix-phase1-data-photos.Rmd")  # restore inline if stranded in hold
move_to_hold("2300-Attachment_pdf_phase_1_dat.Rmd")          # stub belongs in hold for gitbook

# Build
rmarkdown::render_site(output_format = 'bookdown::gitbook', encoding = 'UTF-8')

# Auto-open results chapter (or fall back to index.html)
results_html <- list.files("docs", pattern = "^results", ignore.case = TRUE, full.names = TRUE)[1]
if (is.na(results_html)) results_html <- "docs/index.html"
if (file.exists(results_html)) system(paste("open", shQuote(results_html)))
