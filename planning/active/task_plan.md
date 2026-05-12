# Task: Add floodplain delineation appendix — Parsnip pilot (#14)

Add a floodplain delineation appendix plus short methods + results sections in the main body that reference it. Pilot is the Parsnip River Watershed Group; the build script is generic so future reporting years can extend to other FWCP Peace watersheds.

The appendix introduces floodplains as a second axis to fish-passage assessment (lateral connectivity, off-channel rearing, wetland refugia) and presents the modelled floodplain footprint plus a summary table of off-channel habitat units within it.

## Phase 1 — Port build script + seed data

- [x] Create `scripts/gis/` directory
- [x] Copy `flooded/data-raw/wsg_vignette_data.R` → `scripts/gis/floodplain.R`
- [x] Edit script: swap output dir from `inst/vignette-data` to `data/gis`; replace `devtools::load_all()` with `library(flooded)`
- [x] Create `data/gis/` and copy 4 cached files from `flooded/inst/vignette-data/`
- [x] Verify: `ogrinfo data/gis/pars.gpkg` lists 9 layers

## Phase 2 — Port the appendix

- [ ] Copy `flooded/hold/9999-appendix-floodplain.Rmd` → `0870-appendix-floodplain.Rmd`
- [ ] Add YAML frontmatter (matching `0850`/`0860`/`0890` convention)
- [ ] Change heading to `# **Appendix - Floodplain Delineation** {-#app-floodplain}` (matching repo convention)
- [ ] Replace `system.file("vignette-data/...", package = "flooded")` → `"data/gis/..."` paths
- [ ] Remove `library(flooded)` from setup chunk (not needed at render time — only `terra` and `sf`)
- [ ] Verify citations exist in Zotero: `@nagel_etal2014LandscapeScale`, `@hall_etal2007Predictingriver`

## Phase 3 — Body methods + results

- [ ] Add `### Floodplain Delineation` methods paragraph in `0300-methods.Rmd` under `## Planning` (after `tab-bcfp-def` chunk, ~line 213)
- [ ] Add `flood-rollup-body` quiet data-loading chunk in `0400-results.Rmd` (before `## Planning` section, ~line 240) — loads `data/gis/pars.gpkg`, computes rollup stats
- [ ] Add `### Floodplain Delineation` results paragraph in `0400-results.Rmd` under `## Planning` (after habitat modelling results, before `## Fish Passage Assessemnts`, ~line 257)
- [ ] Update cross-refs in body text: `\@ref(app-floodplain)`

## Validation

- [ ] `bookdown::render_book()` completes without error
- [ ] `/code-check` clean on each commit
- [ ] PWF checkboxes match landed work
- [ ] `/planning-archive` on completion
