# Fast pagedown PDF build for iterating on PDF rendering.
#
# Mirrors `scripts/run.R` block 2 with the same robustness fixes the
# gitbook iter has: explicit CRAN mirror, defensive cleanup, auto-open
# of the rendered PDF. Auto-toggles `gitbook_on` FALSE in index.Rmd at
# start and restores TRUE via `on.exit` so a crash doesn't leave the
# repo in PDF mode.
#
# Usage:
#   Rscript scripts/run_pagedown_iter.R
#
# When verifying full ship readiness, use scripts/run.R instead — it
# also rebuilds the heavy Phase 1 appendix subset.

options(repos = c(CRAN = "https://cloud.r-project.org"))

# --- Auto-toggle gitbook_on FALSE in index.Rmd, restore TRUE at end -----
# Wrapped in a function so on.exit attaches to a frame (top-level on.exit
# in Rscript silently no-ops — bit me on first run, gitbook_on stayed FALSE).

toggle_gitbook_on <- function(value) {
  txt <- readLines("index.Rmd")
  i <- grep("^gitbook_on <- (TRUE|FALSE)\\s*$", txt)
  if (length(i) == 0) stop("gitbook_on toggle line not found in index.Rmd")
  txt[i[1]] <- sprintf("gitbook_on <- %s", value)
  writeLines(txt, "index.Rmd")
}

build_pdf <- function() {
  on.exit(toggle_gitbook_on("TRUE"), add = TRUE)
  toggle_gitbook_on("FALSE")

staticimports::import()
source('scripts/staticimports.R')

# --- Filename derivation -------------------------------------------------
# pagedown writes <book_filename>.html in repo root using book_filename
# from _bookdown.yml. Peace currently has the template's book_filename
# (template-spawn drift). Read both so the script doesn't have to guess.

yml      <- yaml::read_yaml("_bookdown.yml")
input_html_stem <- yml$book_filename             # what pagedown actually produces

idx_yml  <- rmarkdown::yaml_front_matter("index.Rmd")
output_pdf_stem <- basename(idx_yml$params$repo_url)  # what we want the PDF named

input_html  <- paste0(input_html_stem, ".html")
output_pdf  <- file.path("docs", paste0(output_pdf_stem, ".pdf"))

# --- Move 0600 appendix out (per run.R block 2: too big for PDF) ---------
if (file.exists('hold/0600-appendix.Rmd')) {
  file.rename('hold/0600-appendix.Rmd', '0600-appendix.Rmd')
}
file.rename('0600-appendix.Rmd', 'hold/0600-appendix.Rmd')

# Restore 0600 even on render crash (so the repo doesn't get stranded)
on.exit({
  if (file.exists('hold/0600-appendix.Rmd') && !file.exists('0600-appendix.Rmd')) {
    file.rename('hold/0600-appendix.Rmd', '0600-appendix.Rmd')
  }
}, add = TRUE)

# --- Render pagedown HTML ------------------------------------------------
rmarkdown::render_site(output_format = 'pagedown::html_paged', encoding = 'UTF-8')

# --- Restore 0600 appendix ----------------------------------------------
file.rename('hold/0600-appendix.Rmd', '0600-appendix.Rmd')

# --- Chrome print HTML -> PDF -------------------------------------------
cat(sprintf("\nPrinting %s -> %s ...\n", input_html, output_pdf))
pagedown::chrome_print(
  input_html,
  output  = output_pdf,
  timeout = 300
)

# --- Clean up the intermediate HTML (too big to commit) ------------------
if (file.exists(input_html)) file.remove(input_html)

# --- Auto-open the PDF ---------------------------------------------------
if (file.exists(output_pdf)) {
  cat(sprintf("PDF size: %.1f MB\n", file.size(output_pdf) / 1024^2))
  system(paste("open", shQuote(output_pdf)))
} else {
  cat("WARN: expected PDF was not produced.\n")
}

}  # close build_pdf()
build_pdf()
