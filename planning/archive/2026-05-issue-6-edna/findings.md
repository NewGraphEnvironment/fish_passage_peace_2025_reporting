# Findings — Integrate eDNA results into Peace 2025 report (#6)

## Issue context

## Problem

Peace 2025 Results chapter (`0400-results.Rmd`) has a placeholder stub for eDNA results ("INCLUDE LAB RESULTS" tag). UNBC returned 2025 batch results 2026-04-10. Peace report needs to consume them, integrate findings, and render correctly in BOTH the gitbook (HTML) and pagedown (Chrome PDF) builds.

## Self-containment principle

Peace must build cleanly from `git clone` with no cross-repo runtime dependencies. The upstream eDNA wrangle pipeline lives in `fish_passage_template_reporting/scripts/edna_unbc_results_explore.R` (single source of truth for CSV production), but its outputs are committable and the map-build is a transformation Peace can do locally.

So: Peace gets a snapshot of the analytic CSVs + a Peace-specific map-build script that filters and renders. No runtime path into the template repo, no runtime dependency on m1rr0r.

## Proposed Solution

### Placement (hybrid — wedzin kwa narrative-first pattern)

- **Main Results subsection** (`0400-results.Rmd`): short 1-2 paragraph narrative + one high-level summary table (sites × species, confirmed/not detected counts). Link out to thematic appendix + Peace map.
- **New thematic appendix** (`08xx-Appendix-edna.Rmd`): per-site detection table, per-species rollup, QA / retest summary, link to Peace map.
- **Per-site appendix mentions** (only for the 3 Peace per-site appendices overlapping eDNA-sampled sites): brief subsection with site-specific results.

### Peace-local map build

- New script in `scripts/` (e.g., `scripts/edna_map_peace.R`): reads local analytic CSVs, filters by `params$wsg_code`, produces `data/edna_unbc_results_2025_peace_map.html`
- Map file rides along with whatever Peace uses for publishing (m1rr0r interim, eventual permanent host) — co-located with rendered report assets, NOT a separate m1rr0r-only artifact
- Report links to the map at the report's own published location (relative path in gitbook, whatever target URL is current at PDF build time)

### Data snapshot in Peace `data/`

Copy from template repo (one-time, refreshable when source updates):

- `data/edna_unbc_results_2025_analytic.csv`
- `data/edna_unbc_results_2025_by_site_target.csv`

Source of truth for production: `fish_passage_template_reporting/scripts/edna_unbc_results_explore.R`. Updates to the wrangle pipeline land there → CSVs regenerated → snapshots copied into Peace. Document the refresh procedure in a script header (no new README until pattern reused).

### gitbook vs pagedown PDF branching (cross-cutting concern)

Each piece of eDNA content needs a strategy for both output formats. Captured here as the eDNA-specific application of a pattern that will recur across the broader restructure.

| Element | gitbook (HTML) | pagedown (Chrome PDF) |
|---|---|---|
| **Summary table** (Results) | DT interactive (sortable, filterable) | Static `kable` / `fpr_kable` |
| **Detail tables** (Appendix) | DT interactive | Static `kable` |
| **Map** | Either iframe-embed local map URL OR text link | Text link only (interactive HTML can't render in PDF); optionally inline static screenshot |
| **Prose** | "Interactive map below" / "use toggles to filter species" | "Map available at <URL>"; remove gitbook-only language |

Use the existing `eval = gitbook_on` / `eval = identical(gitbook_on, FALSE)` chunk gate pattern (see `index.Rmd` setup chunk + bookdown conventions).

## Out of scope

- Methods section — already present and generic in `0300-methods.Rmd` lines 391-416; just verify
- Broader Results chapter restructure (chunk reduction, narrative-first pattern, thematic appendix scaffolding for non-eDNA content) — separate issue
- bcfishpass parquet port — separate concern
- Crate-ifying the eDNA pipeline — deferred until pattern proven in 2+ repos
- gitbook/pagedown patterns for non-eDNA content — informed by what we learn here, applied in the Results-restructure issue
- Permanent publishing host (replacing m1rr0r as the eventual home for shared report assets) — separate concern

## Test plan

- [ ] Peace builds from `git clone` with no cross-repo path dependencies
- [ ] Map script generates `edna_unbc_results_2025_peace_map.html` from local CSVs, filtered to Peace sites only
- [ ] gitbook build renders Results subsection cleanly (interactive table, narrative, working link to map)
- [ ] pagedown PDF build renders Results subsection cleanly (static table, no "interactive" language, URL visible)
- [ ] Thematic appendix renders in both formats
- [ ] Per-site appendix mentions render in both formats where applicable

Relates to NewGraphEnvironment/fish_passage_template_reporting (eDNA pipeline source — analytic CSVs)

## Initial known facts

- Peace baseline: `0400-results.Rmd` 738 lines, 7 sections, 18 chunks
- Per-site appendices in Peace: 199663 (Trib to Parsnip), 203597 (Trib to Nation), 203605 (Trib to Williston Reservoir)
- Methods eDNA section in Peace: lines 391-416 of `0300-methods.Rmd` — generic, already lift-ready
- Template eDNA pipeline outputs (as of 2026-05-01):
  - `edna_unbc_results_2025_analytic.csv`: 804 rows × 57 cols (sample × assay)
  - `edna_unbc_results_2025_by_site_target.csv`: per (site × species) rollup with `lab_ids` column
- Combined-region map (template, NOT what Peace will link to): `https://www.newgraphenvironment.com/m1rr0r/fish_passage_template_reporting/edna_unbc/edna_unbc_results_2025_map.html`

## Resources

- Issue: https://github.com/NewGraphEnvironment/fish_passage_peace_2025_reporting/issues/6
- Template repo (eDNA pipeline source): `~/Projects/repo/fish_passage_template_reporting`
- Wedzin kwa restructure reference: `~/Projects/repo/restoration_wedzin_kwa_2024` (commits c220065, db6f7f1)
- Bookdown conventions: see CLAUDE.md (`gitbook_on` chunk gating pattern in setup section)
