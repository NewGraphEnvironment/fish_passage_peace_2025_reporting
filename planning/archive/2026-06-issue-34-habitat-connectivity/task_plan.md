# Task: Showcase the link Parsnip habitat & connectivity vignette as a report appendix (#34)

Port the `link` package vignette `pars-habitat-connectivity.Rmd` into a new Peace
report appendix using the `/vignette-to-appendix` skill (recipe: soul#50), and wire
explicit cross-references to it from the Methods and Results sections that already
describe the `fresh` + `link` framework as "in development". Goal: the reader is sent
from the framework prose straight to a worked Parsnip example (bull-trout parity vs
bcfishpass + Arctic grayling extension).

Source: `~/Projects/repo/link/vignettes/pars-habitat-connectivity.Rmd` (link main @ 29e3e92, v0.43.0).
Cached data: `link` `inst/vignette-data/pars.gpkg` + `pars_parity.rds`.

## Phase 1 — Pre-flight (gating; nothing else proceeds without this)

- [x] Confirm `~/Projects/repo/link` on `main` and vignette + both data files present (done in init)
- [x] Run `/vignette-to-appendix` in report-only mode → report at `planning/active/vignette-to-appendix-report.md`, drafts in scratchpad, review scaffold at `planning/active/review-habitat-connectivity.md`
- [x] Appendix slot + slug DECIDED: `0760-appendix-habitat-connectivity.Rmd` in the `07X0` group, anchor `#app-habitat-connectivity` — ordered by first body reference. Override the skill's `08X0` default.
- [x] Filename collision FOUND: source `pars.gpkg` (11.55 MB) ≠ existing `data/gis/pars.gpkg` (12.99 MB floodplain) → mandatory AOI-neutral rename to `habitat-connectivity.{gpkg,rds}`. Copy in Phase 2; commit the gpkg (decided).
- [x] Dependency check: `link` = build-script-only (drop `library(link)`); render-time `gq` is MISSING from `scripts/packages.R` — must install + add. `sf` already loaded.
- [ ] **Gate**: user reviews the report-only draft + report before Phase 2 apply

## Phase 2 — Appendix transfer

- [x] Hand-placed the reviewed draft → `0760-appendix-habitat-connectivity.Rmd` (title: "Parsnip River Habitat and Connectivity Modelling")
- [x] YAML stripped; appendix heading + anchor `{-#app-habitat-connectivity}`
- [x] `system.file()` paths rewritten → `data/gis/habitat-connectivity.{gpkg,rds}`
- [x] Chunk labels prefixed `link-` (link-setup, link-params, link-load, link-parity-table, link-parity-pct, link-symbology, link-map-bt, link-map-gr, link-map-detail)
- [x] Copied + renamed data into `data/gis/`; added `gq` to `scripts/packages.R` + installed (render-time dep); dropped `library(link)`
- [x] `_bookdown.yml` auto-orders by filename — `0760` slots between `0750` and `0835`, no manifest edit needed
- [x] Maps are static base-R/sf plots → carry to PDF, no interactive-widget swap

## Phase 3 — Body wiring

- [x] Methods: cross-ref added to the `fresh` + `link` paragraph (`0300-methods.Rmd`)
- [x] Results: cross-ref added to the `fresh` + `link` / Arctic grayling paragraph (`0400-results.Rmd`), with figure refs
- [x] `\@ref()` anchors resolve both directions (verified in gitbook: methods + results → appendix; figs 5.19/5.20/5.21)

## Phase 4 — Build + verify

- [x] gitbook build (`scripts/run_gitbook.R`) — appendix renders (`app-habitat-connectivity.html`), 3 maps embedded, params+parity tables present, cross-refs resolve. NOTE: required two fixes — (1) renamed local `params`→`param_tab` (collided with bookdown's locked YAML `params`); (2) reinstalled `gq` from local HEAD (pak had a STALE `gq` lacking `gq_tmap_classes()` widths).
- [ ] pagedown build (`scripts/run_pagedown.R`) — maps render static in PDF, no scroll/overflow, legend not clipped
- [x] No new bib keys — vignette cites no `@keys` (COSEWIC/blue-list mentioned narratively only)

## Phase 5 — Ship

- [ ] NEWS entry + version bump
- [ ] PR (Relates to #34; link#215 as source); merge
