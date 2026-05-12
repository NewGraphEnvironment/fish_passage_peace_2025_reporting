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
