# fish_passage_peace_2025_reporting 0.7.0 (2026-05-14)

* Modernize "Statistical Support for Habitat Modelling" — promoted from H4 under `## Planning — Habitat, Connectivity and Floodplain Modelling > ### Habitat Modelling` in `0300-methods.Rmd` to a top-level H2 sibling of Fish Passage Assessments. New content covers: Channel Width Bayesian work (Thorley & Irvine 2021), Bayesian SSN + air2stream stream-temperature modelling with Poisson Consulting citing both `@hill_etal2024Spatialstream` (Nechako 2022b) and `@hill_etal2025Spatialstream` (Skeena 2025), Growing-Season Degree Days as productivity-relevant metric, `water-temp-bc` as canonical hydrometric / water-quality data layer, and a forward-looking paragraph naming `fresh` + `link` + `water-temp-bc` + `bcfishobs` as the trajectory. Frames as extension-not-supersession of canonical `bcfishpass` + `fwapg` + `bcfishobs` stack. Ports template PR #193 / template #191.
* Add `## Statistical Habitat Modelling Outputs` H2 in `0400-results.Rmd` describing methods → downstream consumers and previewing Arctic grayling intrinsic-habitat + calibration-against-`bcfishobs` trajectory.
* Add Executive Summary callout naming the habitat-modelling framework + version-URL framing so reviewers know the live URL serves the latest tagged version (submit-PDF-is-a-snapshot framing).
* Bib: add `@misc{hill_etal2025Spatialstream,...}` (Poisson Skeena 2025 report) — hand-bombed to references.bib alongside `update_bib: FALSE` interim (key not yet registered in Zotero/BBT; proper add tracked as follow-up).

# fish_passage_peace_2025_reporting 0.6.0 (2026-05-14)

* Move FISS species table out of body Background into a new dedicated appendix (`0700-appendix-fish-species.Rmd`) with conditional gitbook/PDF render. Gitbook shows wide one-column-per-WSG table; PDF collapses presence to a comma-separated `Present in WSGs` list — unblocks paged.js PDF builds at 16 WSGs (was overflowing at this scope). Preserves Peace-specific Dolly Varden footnote. Ports template PR #190 / template #188. ([#27](https://github.com/NewGraphEnvironment/fish_passage_peace_2025_reporting/issues/27))
* Update `scripts/run_pagedown_iter.R` — `bookdown::render_book(envir = globalenv())` instead of `rmarkdown::render_site` so fresh-Rscript PDF builds don't fail on lazy-default lookups in `fpr::fpr_kable(font = font_set)` / `my_tab_caption()`. See [soul `bookdown.md`](https://github.com/NewGraphEnvironment/soul/commit/f970830) for the convention.
* `scripts/packages.R` — guard `if(params$update_packages)` with `exists("params")` so the script sources cleanly outside a render with `params` bound.

# fish_passage_peace_2025_reporting 0.5.1 (2026-05-14)

* Add `update_bcfishpass` YAML switch for build portability and post-release freezing — three refresh triggers (YAML flip, missing version file, or `force_bcfishpass_rebuild`); otherwise builds read cached files with no DB connection. Migrate `bcfishpass_crossings_vw` from sqlite to parquet (zstd-9; sqlite shrunk from 26.8 MB to 2.6 MB). Expand WSG list to FWCP Peace Region full extent (16 WSGs) — matches the climate departure appendix scope. Source `0100-load-bcfishpass-data.R` from `index.Rmd` so the switch affects builds. ([Issue #186 in template](https://github.com/NewGraphEnvironment/fish_passage_template_reporting/issues/186))

# fish_passage_peace_2025_reporting 0.5.0 (2026-05-13)

* Add three monitoring appendices (PSCIS 125179 Trib to Missinka, 125231 Trib to Table, 198692 Kerry Lake) with lean structure: intro + Monitoring Form + Fish Sampling + eDNA per-position table + Conclusion. Kerry framed as pre-remediation baseline. 125179 includes 125180 reference-site eDNA. Add `## Engage Partners` section at top of Results pulling `data/communications/partners_2025.csv` (organization + topic columns; personal-name detail kept in CSV for reference). Rewrite Results Monitoring section with internal anchors + effectiveness/baseline distinction. Exec summary closing paragraph cross-refs Engage Partners. Site-ID correction: 125231 (not 125131) per the 2023 prior-year appendix ([Issue #24](https://github.com/NewGraphEnvironment/fish_passage_peace_2025_reporting/issues/24))

# fish_passage_peace_2025_reporting 0.4.1 (2026-05-13)

* Modernize executive summary (drop stale Fraser fragments and outdated recommendations; lead with FWCP Peace Region + 2025 fieldwork WSGs; add FWCP 2026 funding commitments at PSCIS 199663 and 203597; add eDNA program context, 3-site monitoring with baseline/effectiveness distinction, and the two new analytical dimensions floodplain + climate departure). Collapse Intro past-reports list to inline citations. Site appendix conclusion updates for 199663 and 203597 capturing FWCP 2026 funding outcomes. eDNA map deployed to `docs/` so report links resolve. Fish sampling chunks enabled with narrative ([Issue #21](https://github.com/NewGraphEnvironment/fish_passage_peace_2025_reporting/issues/21) tracks the `run.R` refactor still pending)

# fish_passage_peace_2025_reporting 0.4.0 (2026-05-13)

* Add `## Approach` section to background framing fish passage work as risk classification under cost/scale/multi-agency constraints, with infrastructure-legacy context. Add `## Floodplains and Watershed Function` background section. Tighten floodplain methods/results paragraphs and merge appendix narrative (no separate Methods/Results subheadings). Add municipalities layer to build script and detail map. Remove duplicate protocol-context paragraph from results — now lives in Approach.

# fish_passage_peace_2025_reporting 0.3.1 (2026-05-13)

* Restructure GIS sections and appendix order; relocate AI disclosure to YAML and hide Acknowledgement from sidebar TOC. Move amalgamated results tables to new Assessment Data Summary appendix; remove `dff-2022` references throughout ([Issue #18](https://github.com/NewGraphEnvironment/fish_passage_peace_2025_reporting/issues/18))

# fish_passage_peace_2025_reporting 0.3.0 (2026-05-12)

* Add climate departure body section and appendix for FWCP Peace Region (`0880-appendix-climate-departure.Rmd`): ~16 figures and 5 tables covering temperature trends, precipitation, snowpack timing, spatial patterns, per-ecoregion variation, and watershed-group ecoregion mapping. Add methods and results paragraphs in main body under Planning with inline climate statistics. Port cached data via `scripts/cd_inputs_snapshot.R` from `cd` package v0.3.0 ([Issue #16](https://github.com/NewGraphEnvironment/fish_passage_peace_2025_reporting/issues/16))

# fish_passage_peace_2025_reporting 0.2.0 (2026-05-11)

* Add floodplain delineation appendix for Parsnip River Watershed Group pilot (`0870-appendix-floodplain.Rmd`): summary table, watershed-wide and detail terra maps, narrative on lateral connectivity for fish passage. Port build script (`scripts/gis/floodplain.R`) and cached data (`data/gis/`) from `flooded` package. Add methods and results paragraphs in main body under Planning ([Issue #14](https://github.com/NewGraphEnvironment/fish_passage_peace_2025_reporting/issues/14))

# fish_passage_peace_2025_reporting 0.1.4 (2026-05-11)

* Add standalone PDF executive summary: `_executive_summary_pdf.Rmd` wrapper, `scripts/build_exec_pdf.R`, PDF download link in gitbook chapter. Strip `[@citekey]` refs from previous-work lists; fix hardcoded PDF name to derive from `_bookdown.yml`.

# fish_passage_peace_2025_reporting 0.1.3 (2026-05-08)

* Move Collaborative GIS Environment layer table out of mid-results into new appendix `0890-appendix-collaborative-gis.Rmd` (anchor `#app-gis`); section heading + tightened prose moved to end of results, matching the `restoration_wedzin_kwa_2024` pattern
* Move UAV Imagery catalogue out of "Aerial Imagery" subsection into new appendix `0860-appendix-uav-imagery.Rmd` (anchor `#app-uav`)
* Add eDNA-detected species (clean detections) to Phase 2 habitat confirmation overview table via `data/habitat_confirmations_priorities.csv` edits
* Fix anzac cite drift: `@beaudry2013Assessmentassignment` → `@beaudry2013Assessmentassignmenta` (libID 9 suffix shift after BBT `citekeyFormat` pref change)
* Trim Acknowledgement preamble; fix hardcoded path in `scripts/01_prep_inputs/0130_wrangle_form_pscis.R`

# fish_passage_peace_2025_reporting 0.1.2 (2026-05-08)

* Consume `fp_sites_tracking.parquet` snapshot from upstream fptr (v0.0.2) instead of querying postgres live; new `scripts/fp_inputs_snapshot.R` mirrors the existing eDNA pattern; Peace now builds from a fresh clone with no DB access at runtime ([Issue #10](https://github.com/NewGraphEnvironment/fish_passage_peace_2025_reporting/issues/10))

# fish_passage_peace_2025_reporting 0.1.1 (2026-05-05)

* Repair 23 drifted citation keys in prose; pin clean keys on 2 `&`-blocked Zotero entries; flip `update_bib: TRUE` so future drift is caught at build time ([Issue #7](https://github.com/NewGraphEnvironment/fish_passage_peace_2025_reporting/issues/7))

# fish_passage_peace_2025_reporting 0.1.0 (2026-05-05)

* Integrate eDNA results into Peace 2025 report (#6, PR #8)
