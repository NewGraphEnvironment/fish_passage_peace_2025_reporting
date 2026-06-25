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

- [ ] `/vignette-to-appendix --apply` (or hand-place the reviewed draft) → write `0760-appendix-habitat-connectivity.Rmd`
- [ ] Strip vignette YAML; convert to appendix heading with anchor `{-#app-habitat-connectivity}`
- [ ] Rewrite `system.file()` paths → `data/gis/<file>`
- [ ] Prefix chunk labels with `link` (e.g. `map-link-bt`, `tab-link-parity`)
- [ ] Add the appendix to `_bookdown.yml` rmd ordering in the right slot
- [ ] Confirm static `tmap`/base-R maps (carry to PDF) — no interactive-widget swap needed

## Phase 3 — Body wiring

- [ ] Methods: add cross-ref to the appendix in the `fresh` + `link` framework paragraph (`0300-methods.Rmd`, *Statistical Support for Habitat Modelling*)
- [ ] Results: add cross-ref in the `fresh` + `link` / Arctic grayling paragraph under *Statistical Habitat Modelling Outputs* (`0400-results.Rmd`)
- [ ] Confirm `\@ref()` anchors resolve both directions

## Phase 4 — Build + verify

- [ ] gitbook build (`scripts/run_gitbook.R`) — appendix renders, 3 maps appear, parity table present, cross-refs resolve
- [ ] pagedown build (`scripts/run_pagedown.R`) — maps render static in PDF, no scroll/overflow, page breaks sane
- [ ] Resolve any new bib keys the vignette introduces (COSEWIC bull trout, Arctic grayling refs)

## Phase 5 — Ship

- [ ] NEWS entry + version bump
- [ ] PR (Relates to #34; link#215 as source); merge
