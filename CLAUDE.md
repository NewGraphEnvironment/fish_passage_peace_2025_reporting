# CLAUDE.md — fish_passage_peace_2025_reporting

Bookdown report for the 2025 SERNbc / FWCP Peace Region fish passage work. The rendered gitbook and PDFs are the tracked build output under `docs/`; source lives in the numbered `*.Rmd` chapter files and `scripts/`.

## Working Conventions

### Bump the version before building, not after

The report title page renders the version live from `DESCRIPTION` — `index.Rmd` line 24 is `` | Version `r desc::desc_get_version()` `` followed by the render date. If you build and *then* bump, the title page still shows the old version and you must rebuild.

**Why:** a release build that stamps the wrong version on the title page is a silent error — it looks done but ships the previous version number. This cost a full extra gitbook rebuild during the v0.11.0 work.

**How to apply:** for a release build, in order:
1. `desc::desc_set_version("X.Y.Z")` and `desc::desc_set("Date", "<today>")`
2. Add the `NEWS.md` section for the new version
3. Build: `source('scripts/run_gitbook.R')` (web) and `scripts/run_pagedown.R` (print PDF); `scripts/run_pagedown_app1.R` regenerates the Appendix 1 attachment
4. Commit the sources **and** all regenerated outputs together — `docs/`, the top-level `fig/` figures, and `session_info.csv` — matching the repo's "Rebuild docs + PDFs" commit pattern
