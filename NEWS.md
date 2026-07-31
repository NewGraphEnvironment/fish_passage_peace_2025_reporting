# fish_passage_peace_2025_reporting 0.13.0 (2026-07-30)

* Fix the empty "Summary of Phase 2 habitat confirmation details" table in Results. The chunk filtered with `stringr::str_like(Location, 'upstream')`, but the values are capitalised ("Upstream") and `str_like()` became case sensitive in stringr 1.6.0, so the filter silently matched nothing. The underlying data was present throughout; the table now renders the three Phase 2 upstream survey summaries (PSCIS 199663, 203597, 203605).
* Scope the historic fish-observation query (`scripts/02_reporting/0145-analyze-fish.R`) to `params$wsg_code_field` rather than the region-wide `params$wsg_code`. The cached extract already covered only the five field watershed groups, matching the figure captions; the query did not, so any `derive_params: TRUE` rebuild would have silently widened the data to all 16 watershed groups and left the captions understating their own figures.

# fish_passage_peace_2025_reporting 0.12.0 (2026-07-30)

Second round of FWCP review-response edits — factual corrections, a community-engagement section, and wording fixes.

* Add a McLeod Lake Indian Band subsection to Results — Engage Partners, addressing the reviewer's comment that the report did not identify community engagement. Covers MLIB technician integration across all aspects of the program (data transcription, eDNA filtration, electrofishing, fish processing, routine effectiveness evaluations), the UNBC-delivered electrofishing training course hosted in the community and part-funded through this project, and the field programme spanning more than ten sites in tributaries to the Table River and Kerry Lake.
* Reframe the executive-summary purpose paragraph in collaborative, forward-looking terms — what the information base is for and how it readies the project to act with partners — replacing framing that read as disclaiming the partner-agreement constraint. Removes reliance on cross-reference links.
* Correct the Recommendations pointer for priority barriers: high and moderate priorities are presented on the assessment-results map (Figure \@ref(fig:map-interactive)), not in the site-details table, which holds supporting detail and per-site report links.
* Partner table caption now states the engagement period (May 2025 - May 2026) rather than the project year.
* Correct the scope stated in the three historic fish-observation figure and table captions (stream gradient, channel width, watershed size). The captions listed all 16 FWCP Peace watershed groups, but the underlying cached data (`data/inputs_extracted/fiss_sum.csv`) covers only the five field watershed groups — Carp Lake, Crooked River, Nation River, Parsnip Arm, and Parsnip River. Captions now use `wsg_names_field`, matching the data. The fish-species-by-watershed-group appendix is unchanged; its table genuinely spans all 16 groups.
* Background: note that filling of the Williston Reservoir also flooded the Finlay reach, alongside the Parsnip River and major tributary valleys.
* Replace the overview map with the 2025 edition (`fig/fishpassage_2025_fwcp_progress.jpeg`, rendered from the source PDF at 300 dpi). The new map distinguishes the full modelled-connectivity extent across all 16 watershed groups from the five watershed groups where field work was concentrated, and symbolises sites by project phase — directly addressing the reviewer's confusion between the modelled and field-assessed areas. Caption updated to describe the new symbology.

* Arctic grayling / Brassy Minnow — correct the COSEWIC status for Brassy Minnow (*Hybognathus hankinsoni*) from blank to Special Concern (SC) in the fish-species-by-watershed-group table. Hand-patched at the derived-data layer (`data/inputs_extracted/fiss_species_table.csv`); source fix tracked upstream in [NewGraphEnvironment/fishbc#2](https://github.com/NewGraphEnvironment/fishbc/issues/2).
* Sinclar Forest Products — update the Kerry Lake FSR narrative: as of end of June 2025 Sinclar could not plant the cutblocks the FSR accesses this spring as planned, so the planned road decommissioning / removal of PSCIS 198692 and 198693 is deferred and cannot proceed this year. The Kerry Lake baseline (PSCIS 198692) holds until they proceed. Updated in the executive summary and recommendations.
* Water temperature — remove water-temperature data from the site-level effectiveness-monitoring lists (executive summary and recommendations); it is a distinct, condition-tracking program that feeds intrinsic-habitat modelling, not an effectiveness-monitoring method. Clarified the water-temperature recommendation accordingly.
* Community of practice — change "build" to "support" a community of practice (executive summary and recommendations), per the reviewer's note that the project should support rather than lead one.
* Fix watershed-group naming — "Carp River" → "Carp Lake" (the Freshwater Atlas watershed-group name) in the executive summary and results, and add Crooked River to the executive-summary fieldwork list so the five field-season watershed groups are stated consistently.
* Remove "picking battles carefully" from the recommendations preamble (reviewer wording flag); fix a typo ("accordiong" → "according") in the methods UAV-imagery section.

# fish_passage_peace_2025_reporting 0.11.0 (2026-07-09)

Addresses review comments from the Fish and Wildlife Compensation Program on the submitted report.

* Fix an incorrect scope claim in the Background. `wsg_names` derives from `params$wsg_code`, which is the region-wide connectivity-modelling extent, so the Project Location sentence rendered all 16 watershed groups — including Finlay, Ingenika, Toodoggone, and both Omineca groups — as having received field assessments. Add a `wsg_code_field` param and derive `wsg_names_field` from it, rather than narrowing `wsg_code`, which is used correctly at seven other call sites (historic fish-observation plots, the fish species appendix, and the site-assessment-data filter).
* Add a scales-of-work table (`tab-scales`) to the Background giving the extent and purpose of each activity, ordered so field assessments and effectiveness monitoring lead. The reviewer found the analytical layers hard to integrate; naming what each covers and what each is for makes the nesting legible. The climate-departure row states that the analysis does not discriminate between sites, consistent with the appendix's own finding that the regional signal is uniform.
* Move the purpose-and-constraint paragraph in the Executive Summary ahead of the data-product paragraphs, so a reader learns what the work is for before being walked through connectivity modelling, eDNA, floodplain delineation, and climate departure.
* Recommendations and Executive Summary: replace "inherently subjective" and "made opportunistically" with the underlying reasoning — the prioritization criteria are not measured in common units, so no single ordering exists, and the deciding constraint is tenure-holder capacity, which sits outside the project.
* Caption the overview map with the extent it depicts and note that future versions will render the full regional extent.

# fish_passage_peace_2025_reporting 0.10.0 (2026-06-26)

* Add the Parsnip River Habitat and Connectivity Modelling appendix (`0760-appendix-habitat-connectivity.Rmd`), ported from the `link` `pars-habitat-connectivity` vignette. Shows our habitat-and-connectivity modelling for the Parsnip River Watershed Group — reproducing `bcfishpass`'s per-segment bull-trout classification (99.04% parity) and extending the same method to Arctic grayling, a species `bcfishpass` does not yet model — with three per-segment maps. Written in technical-report "we" voice; cross-referenced from the Methods and Results habitat-modelling sections. Cached data added as `data/gis/habitat-connectivity.{gpkg,rds}`; `gq` added to `scripts/packages.R` for the symbology. ([#34](https://github.com/NewGraphEnvironment/fish_passage_peace_2025_reporting/issues/34))

# fish_passage_peace_2025_reporting 0.9.0 (2026-06-24)

* Reorganize the appendices so all thematic `Appendix -` chapters are grouped first — ordered by where they are first referenced in the body (Assessment Data Summary, Fish Species, Climate Departure, Floodplain, UAV Imagery, Collaborative GIS, Phase 1 Data and Photos, Environmental DNA) — followed by the per-site Phase 2 habitat-confirmation memos and then the effectiveness-monitoring memos. Renumbered six thematic appendix files; UAV Imagery and Collaborative GIS no longer trail after the site-specific memos and UAV is out of the `0860` site-memo prefix. Moved the eDNA appendix to `0837` so it sits with the other thematic appendices.
* Results: add explicit named links to the three Phase 2 habitat-confirmation appendices (Tributary to Parsnip River 199663, Nation River 203597, Williston Reservoir 203605) from the Habitat Confirmation Assessments section so the reader is directed to each, matching the effectiveness-monitoring memo treatment. Methods: link the previously-orphaned UAV Imagery appendix from the Aerial Imagery section.
* Table 4.8 (Summary of electrofishing sites) — set `scroll = FALSE` so it renders fully in the PDF.
* Build scripts: rename `run_gitbook_iter.R` → `run_gitbook.R` and `run_pagedown_iter.R` → `run_pagedown.R`; fix the gitbook/PDF Phase 1 appendix swap so the web build carries the full inline appendix (`0835`) while the PDF carries the slim link-stub (`2300`). Split the monolithic `run.R` into a standalone Phase 1 attachment builder `run_pagedown_app1.R` (produces `docs/Appendix_1.pdf`) and removed `run.R`. Updated the README build instructions to the three scripts.
* Gate the species/params derivation block behind a renamed `derive_params` param (was `derive_species`), set `FALSE`, so a routine rebuild does not require a live database connection.

# fish_passage_peace_2025_reporting 0.8.0 (2026-05-14)

* Restore attribution in Statistical Support for Habitat Modelling — names this project + prior SERNbc work as contributor to the statistical-modelling lineage, not just a downstream user. Drops "Poisson" from the methods Stream Temperature lead-ins. Expands the Nechako 2024 paragraph with the causal-pathways / air2stream pivot narrative.
* Correct current-state framing of the `fresh` + `link` habitat-modelling framework across exec summary, methods Trajectory, and results — framework currently consumes `bcfishpass`-style inputs (channel width, gradient, provincial/federal barrier inventories); Arctic grayling intrinsic-habitat layer parameterized on stream size and gradient only; water-temperature integration and `bcfishobs` calibration are *designed-for*, not yet wired in.
* Suppress "(page N)" suffix on internal anchor cross-refs in PDF via `style-pagedown.css` rule.
* Add `#### Contributions to Provincial Connectivity Models` subsection in methods (`0300-methods.Rmd`) describing desktop and field corrections fed back to `bcfishpass` `user_modelled_crossing_fixes.csv` and `pscis_modelledcrossings_streams_xref.csv`; reports 282 + 11 contributions since April 1, 2025 across the FWCP Peace Region. Exec summary picks up a single sentence noting the same.
* Engagement table updates (`data/communications/partners_2025.csv`): removed BC Hydro grant-admin row and UNBC NRESi mixer row; reframed Chu Cho row around mapping support for Mesilinka + Finlay River FWCP planning; expanded Stantec row to include Vitreo Minerals and the McLeod Lake Territory offsetting framing; added BCTS Engineering road-deactivation-plan review row; added MoTi Environmental Services Manager review row; sorted table alphabetically by organization in `0400-results.Rmd`.
* Rewrite Engineering Design section in `0400-results.Rmd` — Kerry Lake replacement shelved in favor of Sinclar-led decommissioning + structure removal at PSCIS 198692 and 198693 in 2025/26; BCTS shared road-deactivation plans for Tributary to Nation River used to scope above-minimum-standards riparian restoration for 2026/27; PSCIS 199663 (Kennedy Siding) lined up by BCTS for spring 2026 site plan and engineering design.
* Update Kerry Lake appendix (`0860-appendix-198692-trib-to-kerry-lake.Rmd`) — surfaces the Sinclar pivot from replacement to road decommissioning + removal of 198692 + adjacent 198693; removes the density figure since some 2025 surveys had no recorded wetted width (tracked as #30); references template #194 for the longer-term wetted-width → channel-width / linear-length density denominator switch.
* Expand Recommendations chapter (`0500-recommendations.Rmd`) into structured subsections — Site-specific restoration and remediation actions; Capacity building and partner integration (UNBC + CNC seed-bank and native-plant-propagation collaboration with Shelby Roberts and Lisa Wood for the Kerry Lake and Tributary to Nation River sites); Watershed-scale context (push climate-departure + floodplain analyses forward, build partner capacity, contextualize fish passage at watershed scale); Prioritization and modelling integration; Monitoring continuation; and Data infrastructure for research and collaboration (`water-temp-bc` as portal model that can be extended/replicated for other regional datasets; same open-access pattern for eDNA data).
* Feather Recommendations themes into Executive Summary as bullet points (looking-ahead block) — Kennedy Siding 199663 with BCTS, Kerry Lake decommission with Sinclar + native-plant collab, continued monitoring at Missinka / Table / Kerry, push climate-departure + floodplain forward, webmap interface, water-temp-bc as regional portal model, centralized eDNA access.
* Add FWCP Rivers, Lakes and Reservoirs Action Plan alignment to Executive Summary citing sub-objective 6 actions PEA.RLR.S06.RI.20, PEA.RLR.S06.RI.19, and PEA.RLR.S06.HB.21 via `@fishandwildlifecompensationprogram2020PeaceRegion`.
* Apply the past-report large-DT online-redirect pattern to four appendices per template #195 — Site Assessment Data Summary (`0810-...`) gets a slim `tab-sites-sum-kable` always-on summary + wide DT details `eval = gitbook_on` + conditional prose; UAV Imagery (`0860-...`) PDF redirects online; Collaborative GIS Layers (`0890-...`) PDF redirects online; Phase 1 Data and Photos attachment (`2300-...`) links refactored to use `params$report_url` and `params$repo_url` so future-year spawns inherit dynamic URLs. Fixed Site Assessment Data summary chunk to filter by `wsg_names` (derived from `params$wsg_code`) instead of hardcoded Fraser watershed-group names.
* Update partner-text exec summary phrasing to include road *and rail* crossing structure barriers within the FWCP Peace Region.
* Add `bcfishpass`, `fresh`, and `link` GitHub Pages hyperlinks in the Executive Summary (smnorris.github.io/bcfishpass, newgraphenvironment.github.io/fresh, newgraphenvironment.github.io/link).
* Temporarily flips `update_bib` to `FALSE` so the hand-bombed `@hill_etal2025Spatialstream` entry survives the render until the key is registered in Zotero/BBT proper. Flip back once that follow-up lands.

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
