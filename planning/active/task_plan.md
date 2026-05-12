# Task: Climate departure body section + appendix — FWCP Peace (#16)

Port climate-departure analysis from the `cd` R package into the Peace 2025 reporting repo: methods paragraph, results paragraph with hidden rollup chunk, and full appendix with ~16 figures and 5 tables. Mirrors the floodplain pattern from #14 but cd IS needed at render time for plotting/summary functions.

## Phase 1: Snapshot script + seed data
- [x] Create `scripts/cd_inputs_snapshot.R`
- [x] Run snapshot to seed `data/gis/cd_peace*` files
- [x] Verify gpkg has 8 layers

## Phase 2: Port the appendix
- [x] Create `0880-appendix-climate-departure.Rmd` with YAML, heading, `{-}` sub-headings
- [x] Update all data paths to `data/gis/cd_peace*`
- [x] Update cross-ref anchors to `#app-climate-departure`
- [ ] Verify 9 citation keys in Zotero

## Phase 3: Body methods + results
- [x] Add `### Climate Departure` methods in `0300-methods.Rmd`
- [x] Add `cd-rollup-body` quiet chunk in `0400-results.Rmd`
- [x] Add `### Climate Departure` results paragraph in `0400-results.Rmd`

## Phase 4: Package dependency + version bump + build
- [x] Add `cd` to system library (no renv in this repo)
- [x] Bump DESCRIPTION 0.2.0 → 0.3.0, NEWS.md entry
- [x] Full bookdown build + verify rendering

## Validation

- [ ] Tests pass
- [ ] `/code-check` clean on each commit
- [ ] PWF checkboxes match landed work
- [ ] `/planning-archive` on completion
