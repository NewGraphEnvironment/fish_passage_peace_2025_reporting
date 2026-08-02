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

- [ ] Download `fish_data_sub_template__qa_tool.zip` and extract `FDS_Template2026-03-11.xlsx`
- [ ] Add to `rfp/inst/extdata/templates/` - the canonical home, already holding `FDS_Template2023-05-03.xls` and `pscis_assessment_template_v24.xlsm`
- [ ] Commit in rfp with `Fixes NewGraphEnvironment/dff-2022#94`
- [ ] Copy the blank into `fish_passage_peace_2025_reporting/data/` as the working template

## Phase 2 - Remove the bootstrap trap

`0210_fiss_export_to_template.Rmd` calls `fpr::fpr_import_hab_con()` four times
(`:57`, `:65`, `:109`, `:143`) purely to harvest target column names - but peace_2025
has no populated workbook, so the script cannot run at all today.

Keep the function; change only its `path`. It is format-agnostic (`excel_sheets` ->
read -> `janitor` -> `fpr_sheet_trim`), and `fpr_sheet_trim` locates the header by
taking the first fully-populated row - which is why it lands on the right row per
sheet without anyone hardcoding one.

- [ ] Pass the **blank** template path to those four calls (the default is
      `data/habitat_confirmations.xls`, which does not exist here)
- [ ] Remove the no-op `fpr::fpr_sp_gpkg_backup()` call at `0210:35` (return discarded at `:140`; UTM update discarded via `write_back_to_path = FALSE`; backup duplicated by `0100_backup_forms.R`)
- [ ] Make `0210` runnable on its own - it currently depends on `form_fiss_site_prep2` from `0205`'s environment
- [ ] Confirm `0210` runs end to end with no `data/habitat_confirmations.xls` present

## Phase 3 - Correctness fixes before any data is written

- [ ] Port the 1:20k -> 1:50k watershed-code fix from the Skeena scripts (fptr#82). `0205_fiss_wrangle.R` is byte-identical across template/peace_2025/fraser_2025 (7246 B), so none of them have it, and these codes feed `step_1_ref_and_loc_info`
- [ ] Resolve gradient units (fptr#217): template computes `AVERAGE(...)/100`, our R column is `average_gradient_percent` with no divisor. Fastest check is comparing against the submitted `PG24-879256_data.xls`

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
