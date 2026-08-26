# Issue #23 — Submit 2025 fish + habitat data to the Province (FDS)

**Status: built and released, not yet submitted.** Archived to free `planning/active/`, not because the work is finished. Issue #23 stays **open** until the submission actually happens.

## What landed

The provincial Fish Data Submission workbook is built programmatically rather than by copy-paste-special, and shipped in **v0.15.0** (PR #39, merge `a70f0dc`). `scripts/03_permit_submission/fds_prep_for_submission.R` reads the four step CSVs the prep scripts produce, applies the submission-only transforms, and writes them into a copy of the blank provincial template.

Committed artifacts under `data/permit_submission/`:

- `PG25-983916.xlsx` — the submission workbook
- `SFCP_Irvine_PG25-983916_100484922.pdf` — the permit
- `step_1_ref_and_loc_info.csv` … `step_4_stream_site_data.csv` — the reviewable intermediates

29 of 32 task-plan boxes were ticked.

## What is still outstanding

- [ ] Run the provincial QA tool (v1.22, Windows / Excel 2010) — optional but recommended
- [ ] **Submit via the WLRS SPO FDS SharePoint site** (`https://bcgov.sharepoint.com/sites/WLRS-FDS`, access via `fishdatasub@gov.bc.ca`); DFO copy if the permit requires it
- [ ] Capture the submission confirmation in the repo

The workbook exists and is releasable; the last mile — actually sending it and recording the confirmation — has not been done or has not been recorded here. Fraser 2025 (`fish_passage_fraser_2025_reporting#26`) sits at the same point, so both are outstanding together.

## Why it is worth reading

The findings file records several traps that cost real time and are not obvious:

- `readxl` misreports row geometry on this template — it skips leading blank rows. Use `tidyxl::xlsx_cells()` for absolute addresses (headers 32/24/19/21, data 33/25/20/22).
- The `Average Gradient (%)` "bug" is a **false alarm, twice reversed**. The cell carries Excel number format `0.0%`, so a percent-formatted cell multiplies by 100 for display and the template's `AVERAGE(...)/100` is correct. Committed as a fix in `f5006c6`, retracted in `75fb638`. Do not re-fix it.
- Do not re-run `0205_fiss_wrangle.R` — it writes back to the field-form geopackages with `delete_dsn = TRUE`, and its `source` column pools all three regions, so running it from one repo rewrites three Mergin projects.
- `0220`'s pit-tag merge was destructive and non-idempotent; a type error was the only thing preventing silent duplication.

## Follow-on

The workflow was ported to the template and generalised in `fish_passage_template_reporting` v0.16.0 (#228) — a season is now configured from `index.Rmd` via `permit_id` and `permit_id_dfo`, so this script is identical across the fish passage repos.

One defect from this work reached the submitted artifact: `step_4_stream_site_data.csv` carries `waterbody_id = 00000NA` on all six rows, because the `00000NA` fix was applied to Step 1 only. Fixed in the template and in Fraser; **not corrected in the Peace workbook**, which is another reason to resolve the submission question before considering this closed.
