# Peace 2025 provincial Fish Data Submission (#23)

## Context

Peace 2025 owes the province a Fish Data Submission (FDS) under scientific fish
collection permit **PG25-983916**. It is the only 2025 season with sampled fish -
97 records in `data/fish_data_tags_joined_2025.csv` (84 Rainbow Trout, 12
unidentified, 1 sucker) with lengths, weights and PIT tags. Fraser 2025 has none;
Skeena 2025 has no reporting repo at all.

**Issue #23's premise is now stale.** It asks us to "build `habitat_confirmations.xls`"
because `2400-Attachment_data.Rmd` links to it. But 2025 is the first season that
does not produce that workbook, and does not need to:

| | 2023 / 2024 | 2025 |
|---|---|---|
| `data/habitat_confirmations.xls` | present (12 MB, committed) | **absent** in peace_2025, fraser_2025, template |
| Report source for habitat | the workbook | `form_fiss_site` (`0130-tables.R:475`) |
| The five habitat averages | Excel formulas | R, via `ngr::ngr_str_df_col_agg()` (`0205_fiss_wrangle.R:143-170`) |

`0130-tables.R` contains **zero** references to `fpr_import_hab_con`. The workbook
stopped being a reporting input and is now only a submission artifact.

So Peace 2025 produces **one** file - `data/permit_submission/PG25-983916.xlsx` -
not two. This removes a 12 MB committed binary and the repo-copy-vs-permit-copy
divergence that `fds_prep_for_submission_2023.Rmd:324-326` flags as unresolved.

Two further facts found while scoping:

- The provincial template we carry (`FDS_Template2023-05-03.xls`) is ~3 years stale
  and the wrong format. Current is **`FDS_Template2026-03-11.xlsx`**, shipped inside
  `fish_data_sub_template__qa_tool.zip`. Column sets are **identical** on all four
  step sheets - 16 / 40 / 20 / 93, same names and same order, compared at absolute
  header rows via `tidyxl::xlsx_cells()`. Adoption is a drop-in. See
  NewGraphEnvironment/dff-2022#94.
- The province still wants the watershed code: Step 1 column 6 is
  `Watershed Code (45 Digit)`, unchanged from 2023. That is the field
  `0210:89` fills via `watershed_code_45_digit = watershed_code_50k`, so the
  1:50k sourcing - and fptr#82 - remain in play.
- The province accepts `.xls` or `.xlsx`, and the QA tool is explicitly optional
  ("Although optional, it is strongly recommended"), running only on Excel 2010 and
  earlier.

**Approach for this season: generate the four step CSVs as today and paste them in
by hand.** The programmatic writer (fptr#216) is viable but unproven end-to-end;
doing the paste once identifies which steps actually hurt, which is the spec for
automating Fraser and Skeena.

## Phase 1 - Adopt the current provincial template

- [x] Download `fish_data_sub_template__qa_tool.zip` and extract `FDS_Template2026-03-11.xlsx`
- [x] Add to `rfp/inst/extdata/templates/` - the canonical home, already holding `FDS_Template2023-05-03.xls` and `pscis_assessment_template_v24.xlsm`
- [x] Commit in rfp with `Fixes NewGraphEnvironment/dff-2022#94` (branch `fds-template-2026`, commit `4a979f1`)
- [x] Copy the blank into `data/templates/`, matching the committed-template convention already used for PSCIS (`data/spreadsheets/pscis_assessment_template_v24.xlsm`)

## Phase 2 - Make 0210 runnable

`0210_fiss_export_to_template.Rmd` could not run in this repo at all. Four separate
faults, only the first of which was visible from the issue:

1. Four `fpr::fpr_import_hab_con()` calls defaulted to `data/habitat_confirmations.xls`,
   which does not exist here.
2. `:52` and `:83` referenced `form_fiss_site_prep2` - an object `0205_fiss_wrangle.R`
   **deletes on exit** (`0205:191`, `rm(list = ls(pattern = "^form_fiss_site_prep"))`).
   It can never be in scope.
3. `params$gis_project_name` / `params$project_year` (`:21`) are absent from the file's
   own YAML block, which declared unrelated and stale keys (`repo_name:
   "fish_passage_template_reporting"`, `job_name: "2024-073-..."`). Knitted standalone
   both resolve `NULL`.
4. `0210:35` was reading the gpkg into `form_fiss_site`, then the reassignment at `:140`
   shadowed it - so the correct data source was fetched and discarded.

**Correction to the approved plan:** it recorded `fpr_sp_gpkg_backup()` as a no-op to
delete. That was wrong. Reading `0205` in full showed it deletes its own prep objects,
so the gpkg re-read *is* the intended data source, and `update_utm = TRUE` /
`return_object = TRUE` are load-bearing. The bug was the stale variable name, not the call.

- [x] Point `fpr_import_hab_con()` at the blank template; read it **once** into
      `fds_names` and pluck **by sheet name** rather than position, so a future sheet
      reorder fails loudly instead of silently
- [x] Rename the gpkg read to `form_fiss_site_qa` (no longer shadowed at `:140`) and
      use it at `:52` / `:83` in place of the deleted `form_fiss_site_prep2`
- [x] Load params from `index.Rmd` front matter via `rmarkdown::yaml_front_matter()` -
      same pattern as `scripts/run_pagedown.R:44`; drop the stale YAML block. Restores
      the `01_prep_inputs/README.md` contract that these are "self sufficient scripts
      with everything in them necessary ... with a clean working environment"
- [x] Verified: `fpr_import_hab_con()` reads the blank `.xlsx` in 2.3 s, returns 7
      sheets, `step_1_ref_and_loc_info` 16 cols and `step_4_stream_site_data` 93 cols -
      matching the `tidyxl` counts, and carrying `watershed_code_45_digit`

## Phase 3 - Correctness fixes before any data is written

- [x] **Watershed codes (fptr#82) - investigated, NO code change.** Porting the Skeena
      parsing would have been a regression. Evidence, from the submitted workbooks:

      | Submission | Groups | Segmentation |
      |---|---|---|
      | skeena_2023, skeena_2024 | 12 | 3-6-5-5-4-4-3-3-3-3-3-3 |
      | peace_2024 | **10** | 3-6-5x7 + orphan trailing digit |

      Raw `watershed_code_50k` is 45 undelimited characters (verified by query), so
      grouping is ours to choose. The alternate parsing at
      `skeena_2024/.../0205_fiss_wrangle.Rmd:193-205` substrings to position 49 against
      a 45-character input - which is what produces peace_2024's trailing `-0`. Both
      Skeena submissions used the 12-group form that `parse_ws_code()` already produces
      here. The 2026 template does not specify a delimiter format; INSTRUCTIONS row 87
      names only the sources (FIDQ, Habitat Wizard). Recorded on fptr#82.

- [x] **Gradient units (fptr#217) - confirmed a defect in the provincial template,
      inherited by every past submission.** From submitted `SM24-882238_data.xls`:

      | #1 (%) | #2 (%) | #3 | #4 (%) | submitted "Average Gradient (%)" | true mean |
      |---|---|---|---|---|---|
      | 2 | 3.5 | 1.0 | - | 0.02166667 | 2.167 |
      | 6 | 5.0 | 3.5 | 2.0 | 0.04125 | 4.125 |

      Exactly 100x low on every row. The template's `AVERAGE(...)/100` writes a
      proportion into a column headed `(%)`, whose inputs are percents. Our R
      `average_gradient_percent` has no divisor, so **the report and the submission
      disagree by 100x for the same sites** - the report matches the label, the
      submission does not. The other four averages are unaffected.

- [ ] **DECISION REQUIRED before Phase 5** - let the template compute (consistent with
      our back catalogue, knowingly wrong), write the R value (correct, but clobbers a
      derived cell and diverges from prior submissions), or ask the province. Their
      formula and their header disagree, so option three first. Contact recorded at
      `fds_prep_for_submission_2023.Rmd:60`.

## Phase 4 - Generate the four step CSVs

- [ ] Run `0205_fiss_wrangle.R` - reads `form_fiss_site_2025.gpkg` from `~/Projects/gis/sern_peace_fwcp_2023/data_field/2025/`, queries `bcfishpass.crossings_vw` for watershed codes, computes the five habitat averages
- [ ] Run `0210_fiss_export_to_template.Rmd` -> `form_fiss_loc_tidy.csv` (step_1), `form_fiss_site_tidy.csv` (step_4)
- [ ] Run `0220_fish_data_tidy.R` -> `fish_data_ind.csv` (step_3), `fish_data_coll.csv` (step_2)
- [ ] Sanity-check row counts against 97 fish and the assessed site list

## Phase 5 - Build the submission workbook

- [ ] Copy the blank template to `data/permit_submission/PG25-983916.xlsx`
- [ ] Fill Step 1 header block: project title "Restoring Fish Passage in the Peace Region - 2025", Company/Agency Other -> New Graph Environment Ltd., Project Type Research, permit `PG25-983916`, RPBio verification fields
- [ ] Paste-special the four CSVs into their sheets. Verified geometry (absolute rows, via `tidyxl::xlsx_cells()`):

      | Sheet | Header row | Data starts | Columns |
      |---|---|---|---|
      | Step 1 (Ref. and Loc. Info) | 32 | **33** | 16 |
      | Step 2 (Fish Coll. Data) | 24 | **25** | 40 |
      | Step 3 (Individual Fish Data) | 19 | **20** | 20 |
      | Step 4 (Stream Site Data) | 21 | **22** | 93 |

      Step 1's start is corroborated by the template's own VLOOKUP range, `'Step 1 (Ref. and Loc. Info)'!$..$33:$..$625`.
- [ ] **Do not paste over derived columns** - Step 4 carries five `AVERAGE(...)` formulas and five `VLOOKUP(...)` pulls from Step 1 that self-populate. Same rule `0140_pscis_export_to_template.R:111` already applies on the PSCIS side
- [ ] Apply the submission transforms from `fds_prep_for_submission_2023.Rmd`: drop `step_4_stream_site_data` rows for small `_ef` sites (fptr#27 - fish and locations stay, only non-conforming habitat rows go), consolidate site identifiers into comments, trim features
- [ ] Record every hand step taken, for the fptr#216 spec

## Phase 6 - QA and submit

- [ ] Run the provincial QA tool (v1.22, Windows/Excel 2010) - optional but recommended; record findings
- [ ] Submit via the WLRS SPO FDS SharePoint site; DFO copy if the permit requires it
- [ ] Capture submission confirmation in the repo

## Phase 7 - Report wiring and propagation

- [ ] `2400-Attachment_data.Rmd:11` - repoint the habitat link at `data/permit_submission/PG25-983916.xlsx`, noting it excludes step_4 habitat rows for small EF sites
- [ ] `2400-Attachment_data.Rmd:15` - fix `fish_data_tags_joined.csv` -> `fish_data_tags_joined_2025.csv`
- [ ] Rebuild the report; confirm both links resolve
- [ ] Port `0205`/`0210` changes back to `fish_passage_template_reporting`. Not optional - the three 2025 scripts are byte-identical today, and skipping this is how peace_2024 and skeena_2024 ended up a generation apart

## Files

| File | Change |
|---|---|
| `rfp/inst/extdata/templates/FDS_Template2026-03-11.xlsx` | new |
| `scripts/01_prep_inputs/0210_fiss_export_to_template.Rmd` | column-name source -> blank template |
| `scripts/01_prep_inputs/0205_fiss_wrangle.R` | watershed-code fix; gradient units if wrong |
| `scripts/03_permit_submission/fds_prep_for_submission_2023.Rmd` | 2025 params (currently hardcoded to `fish_passage_skeena_2023_reporting` / `SM23-814011`) |
| `2400-Attachment_data.Rmd` | two link fixes |
| `data/permit_submission/PG25-983916.xlsx` | new, the deliverable |

Reused rather than rewritten: `fpr::fpr_import_hab_con()` (column names),
`ngr::ngr_str_df_col_agg()` (the five averages), `fpr::fpr_db_query()` (watershed
codes).

Two script-hygiene items found while scoping, to handle in Phase 2 rather than
leave as surprises:

- **`0210:35` calls `fpr::fpr_sp_gpkg_backup()` to no effect.** Its return is
  assigned to `form_fiss_site`, never read, then overwritten at `:140`. It also
  passes `update_utm = TRUE` with `write_back_to_path = FALSE`, so the UTM update
  is computed and discarded. The only surviving effect is a backup that
  `0100_backup_forms.R` already performs for every form. Remove it.
- **`0210` is not standalone.** It uses `form_fiss_site_prep2` (`:52`, `:83`) but
  never defines it - the object comes from `0205`'s environment. The two must run
  in one session, in order, and `0210` cannot be re-run alone after a restart.
  Either thread the object explicitly or read it from the backup CSV.

## Verification

- `0210` and `0220` run from a clean checkout with no `habitat_confirmations.xls`
- Step CSV row counts reconcile: 97 fish in step_3; step_2 rows = one per site/species/life-stage; step_4 excludes `_ef` sites while step_1 retains them
- Opened workbook still shows dropdowns, protection, and evaluated `AVERAGE`/`VLOOKUP` cells in Step 4
- Gradient values match the template's own computed column, not 100x off
- Provincial QA tool run and findings recorded
- Report builds; both attachment links resolve
- Template repo carries the same `0205`/`0210` as peace_2025 afterwards

## Out of scope

- Programmatic workbook writing (fptr#216) - spec'd by this season's paste steps
- Fish into `working.*` + parquet (fptr#215) - not needed to submit
- `crate` 2023 column reconciliation (crate#6)
- Fraser 2025 (fraser_2025_permit#3, Dec 31) and Skeena 2025 (no repo yet)
