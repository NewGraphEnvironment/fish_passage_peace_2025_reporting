# Progress — Peace 2025 provincial Fish Data Submission (#23)

## Session 2026-08-01 (init)

- Archived the completed-but-unarchived PWF for #34 (link Parsnip habitat &
  connectivity appendix) → `planning/archive/2026-06-issue-34-habitat-connectivity/`
  with an outcome README. That work merged via `522b8d7` / `ece0218`; #34 stays open
  pending the deferred pagedown map defect (mybookdown-template#91).
- Plan-mode exploration across fpr, ngr, dff-2022, the template repo and the
  2023/2024 reporting repos. Phases approved by user.
- Created branch `23-submit-2025-fish-habitat-data-to-provinc` off main.
- Scaffolded PWF baseline with the approved phases.

### Scope changed during planning

The issue asks for `data/habitat_confirmations.xls`. That premise is stale — 2025 is
the first season that neither produces nor needs it. The report builds `hab_site`
from `form_fiss_site` and computes the five habitat averages in R. **Peace 2025
produces one file: `data/permit_submission/PG25-983916.xlsx`.**

### Decisions locked

- **Template:** adopt `FDS_Template2026-03-11.xlsx`. Ours is ~3 years stale and the
  wrong format; column sets verified identical on all four step sheets
  (16/40/20/93), so it is a drop-in.
- **Fill method:** paste-special by hand this season. Programmatic writing is viable
  (openxlsx works on the `.xlsx`) but unproven end-to-end; doing the paste once
  produces the spec for fptr#216, and Fraser/Skeena get the automation.
- **Attachment link:** point at the permit submission workbook rather than a
  reconstructed habitat file.
- **Column names:** keep `fpr::fpr_import_hab_con()`, change only its `path` to the
  blank template. `fpr_sheet_trim()` already finds the header row per sheet.

### Corrections made during planning — worth not repeating

- Header/data rows derived with `readxl(n_max=)` were **wrong** (15/23/18/20).
  readxl skips leading blank rows. `tidyxl::xlsx_cells()` gives absolute addresses:
  headers at 32/24/19/21, data at 33/25/20/22. Step 1's start is independently
  confirmed by the template's own VLOOKUP range ending `$33:$625`.
- `fpr::fpr_sp_gpkg_backup()` was listed as a reused dependency; it is a no-op at
  `0210:35` and should be removed instead.

### Next

Phase 1 — download the ZIP, add `FDS_Template2026-03-11.xlsx` to
`rfp/inst/extdata/templates/`, commit in rfp with `Fixes NewGraphEnvironment/dff-2022#94`,
copy the blank into this repo's `data/`.
