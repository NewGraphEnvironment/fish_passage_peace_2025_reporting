# Build the pagedown (print PDF) version of the report.
#
# Swaps the heavy inline Phase 1 appendix (0835-...) out for the slim link-
# stub (2300-...) so the PDF stays light, then renders. Explicit CRAN mirror,
# defensive cleanup, auto-open of the rendered PDF. Auto-toggles `gitbook_on`
# FALSE in index.Rmd at start and restores TRUE via `on.exit` so a crash
# doesn't leave the repo in PDF mode.
#
# Usage:
#   Rscript scripts/run_pagedown.R
#
# To regenerate the standalone Phase 1 attachment PDF (docs/Appendix_1.pdf)
# that the 2300 stub links to, use scripts/run_pagedown_app1.R.

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

# Preload PDF render-time globals so chunks that consume them via lazy defaults
# (e.g. `fpr_kable(font = font_set)`) resolve them via the function's closure
# chain. We pass `envir = globalenv()` to bookdown::render_book below — that
# lets chunks ALSO see these names because globalenv is now the knit env. We
# deliberately do NOT preload `params`: bookdown injects params from YAML into
# the knit env at render time, and pre-binding here would trip the "params
# object already exists in knit environment" guard.
font_set    <<- 9
photo_width <<- "80%"
gitbook_on  <<- FALSE

input_html  <- paste0(input_html_stem, ".html")
output_pdf  <- file.path("docs", paste0(output_pdf_stem, ".pdf"))

# --- Defensive move helpers (report each rename outcome) ----------------
# matches gitbook iter pattern after bare mapply was observed to silently no-op.
move_to_hold <- function(path) {
  if (!file.exists(path)) {
    cat(sprintf("  WARN: %s missing, skipping move-to-hold\n", path))
    return(invisible(FALSE))
  }
  hold_path <- file.path("hold", basename(path))
  if (file.exists(hold_path)) {
    cat(sprintf("  hold/ already has %s, removing first\n", basename(path)))
    file.remove(hold_path)
  }
  ok <- file.rename(path, hold_path)
  cat(sprintf("  %s -> %s : %s\n", path, hold_path, ok))
  invisible(ok)
}
move_back_from_hold <- function(path) {
  hold_path <- file.path("hold", basename(path))
  if (!file.exists(hold_path)) {
    cat(sprintf("  WARN: %s not in hold/, cannot restore\n", basename(path)))
    return(invisible(FALSE))
  }
  if (file.exists(path)) {
    cat(sprintf("  %s already exists, removing first\n", path))
    file.remove(path)
  }
  ok <- file.rename(hold_path, path)
  cat(sprintf("  %s -> %s : %s\n", hold_path, path, ok))
  invisible(ok)
}

# --- Swap Phase 1 appendix: inline (gitbook) -> link-stub (PDF) ----------
# Gitbook renders the full inline Phase 1 data+photos appendix (0835-...),
# which is huge and would land mid-report in the PDF. For the PDF we swap it
# for the slim link-stub (2300-...) that points at the online gitbook page +
# Appendix_1.pdf. Resting state: 0835 at root, 2300 in hold/.
appendix_inline <- "0835-appendix-phase1-data-photos.Rmd"
appendix_stub   <- "2300-Attachment_pdf_phase_1_dat.Rmd"

restore_appendix_layout <- function() {
  if (file.exists(appendix_stub)) move_to_hold(appendix_stub)               # 2300 -> hold
  if (file.exists(file.path("hold", appendix_inline)))
    move_back_from_hold(appendix_inline)                                    # 0835 -> root
}

cat("\n=== Swapping Phase 1 appendix (inline -> link-stub) for PDF ===\n")
move_to_hold(appendix_inline)         # 0835 root -> hold
move_back_from_hold(appendix_stub)    # 2300 hold -> root

# Crash-safe restore to resting state (0835 root, 2300 hold)
on.exit(restore_appendix_layout(), add = TRUE)

# --- Render pagedown HTML ------------------------------------------------
# Use bookdown::render_book so we can pass `envir = globalenv()` — fresh-Rscript
# renders otherwise put chunk-assigned vars (e.g. `my_caption`) in a sibling
# knit_global that helpers sourced into globalenv can't see via their lazy-
# default lookup chain. The old interactive sourced-line-by-line flow side-stepped this because
# globalenv was already pre-populated by prior chunk runs in the same session.
bookdown::render_book(
  input         = "index.Rmd",
  output_format = "pagedown::html_paged",
  encoding      = "UTF-8",
  envir         = globalenv()
)

# --- Restore resting appendix layout (0835 root, 2300 hold) -------------
cat("\n=== Restoring Phase 1 appendix layout (inline at root) ===\n")
restore_appendix_layout()

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
