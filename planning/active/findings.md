# Findings — Peace 2025 provincial Fish Data Submission (#23)

## Issue context

Issue #23 as filed asks for two things: build `data/habitat_confirmations.xls` for
2025, and fix two broken pointers in `2400-Attachment_data.Rmd`:

| Rmd pointer | Actual state |
|---|---|
| `data/habitat_confirmations.xls` | file does not exist; only `data/habitat_confirmations_priorities.csv` present |
| `data/fish_data_tags_joined.csv` | file is at `data/fish_data_tags_joined_2025.csv` |

Permit: `PG25-983916`. Project title: "Restoring Fish Passage in the Peace Region - 2025".
Named monitoring sites: 125179, 198692, 125131.

## The premise shifted before the issue was written

2025 is the first season that does not produce `habitat_confirmations.xls`, and does
not need to.

| Repo | `data/habitat_confirmations.xls` |
|---|---|
| peace_2023, peace_2024, skeena_2024 | present (~12 MB committed binary) |
| **peace_2025, fraser_2025, template** | **absent** |

`scripts/02_reporting/0130-tables.R` has zero references to `fpr_import_hab_con` —
it builds `hab_site` from `form_fiss_site` at `:475`. The five habitat averages are
computed in R via `ngr::ngr_str_df_col_agg()` (`0205_fiss_wrangle.R:143-170`):
`avg_channel_width_m`, `avg_wetted_width_m`, `average_residual_pool_depth_m`,
`average_gradient_percent`, `average_bankfull_depth_m`.

So the workbook is no longer a reporting input. It is only a submission artifact,
and 2025 produces one file rather than two.

Surviving `fpr_import_hab_con()` callers in this repo:

| Caller | Purpose |
|---|---|
| `0210_fiss_export_to_template.Rmd` (`:57`, `:65`, `:109`, `:143`) | harvest target column names only |
| `03_permit_submission/fds_prep_for_submission_2023.Rmd:45` | read a populated workbook |
| `scripts/db-load.Rmd:124` | read *historical* workbooks for backfill, via `lfpr_import_fish_repo()` |

## Provincial template — current version and format

The template ships inside the QA tool package, not standalone:

- ZIP: `fish_data_sub_template__qa_tool.zip` (16 MB)
- Contents: `FDS_Template2026-03-11.xlsx` (3.8 MB) + `QA TOOL_v1.22_Package/`

Ours (`dff-2022/data/templates/FDS_Template2023-05-03.xls`, also
`rfp/inst/extdata/templates/`) is legacy OLE2, 12 MB, authored 2004 — roughly three
years stale and the wrong format.

### Column comparison — identical

Compared at absolute header rows using `tidyxl::xlsx_cells()` (the 2023 `.xls` was
read via a LibreOffice conversion, which round-trips losslessly — see below):

| Sheet | Header row | Data starts | 2023 cols | 2026 cols | |
|---|---|---|---|---|---|
| Step 1 (Ref. and Loc. Info) | 32 | 33 | 16 | 16 | identical |
| Step 2 (Fish Coll. Data) | 24 | 25 | 40 | 40 | identical |
| Step 3 (Individual Fish Data) | 19 | 20 | 20 | 20 | identical |
| Step 4 (Stream Site Data) | 21 | 22 | 93 | 93 | identical |

Same names, same order. Step 1's data start is corroborated independently by the
template's own VLOOKUP range, `'Step 1 (Ref. and Loc. Info)'!$..$33:$..$625`.

**Method note:** an earlier attempt using `readxl::read_excel(n_max = 25)` reported
header rows 15/23/18/20 and could not see Step 1's full width. Those numbers were
wrong — readxl skips leading blank rows, offsetting every index. `tidyxl` gives
absolute addresses and is the reliable tool here.

### Structure

8 sheets: `INSTRUCTIONS`, the four `Step N` sheets, `Species by Common Name`
(hidden), `Species Template Order`, `Admin Only - Pick Lists` (hidden). 101 data
validation dropdowns (18/33/12/38 on the step sheets), stored as inline literal
lists rather than range references. `sheetProtection sheet="true" password="dbeb"`
on 7 of 8. **No macros** — unlike the PSCIS `.xlsm`, which carries a 410 KB
`vbaProject.bin`.

## Submission format and QA tool — verbatim from the province

> "Files must be in .xls or .xlsx format."

> "Although optional, it is strongly recommended, as the QA tool provides clarity on
> required fields and formats, improves the quality of the data submitted, and
> reduces the need to be contacted at a later date regarding data submission issues."

The QA tool "only operates on Microsoft Excel 2010 and earlier versions" — the
reason for the Windows round-trip described at
`fds_prep_for_submission_2023.Rmd:324-326`, and a second source of divergence
between the repo copy and the submitted copy.

Destination: SharePoint Online FDS site, `https://bcgov.sharepoint.com/sites/WLRS-FDS`;
access requests to `fishdatasub@gov.bc.ca`. No deadline stated on the page for
scientific fish collection permits.

## Watershed codes still required

Step 1 column 6 is `Watershed Code (45 Digit)`, unchanged from 2023. That is the
field `0210:89` fills via `watershed_code_45_digit = watershed_code_50k`. The
1:50,000 sourcing (`whse_basemapping.fwa_streams_20k_50k`) describes where the value
comes from, not what the province asks for — so fptr#82 remains in play.

`fds_prep_for_submission_2023.Rmd:59-62` records the wrinkle: we source 1:50k codes
and "the province turns around and converts them back to 1:20,000" (pers. comm. Dave
McEwan, Fisheries Standards Biologist, 778 698-4010).

## Derived columns must not be overwritten

Extracted from Step 4 with `ngr::ngr_xl_map_formulas()`:

```
AVERAGE(channel_width_preferred_for_forestry… : na_12)
AVERAGE(wetted_width : na_20)
AVERAGE(residual_pool_depth : na_28)
AVERAGE(bankfull_depth : na_33)
AVERAGE(gradient_preferred_for_forestry… : na_38) / 100
VLOOKUP('Step 4'!<ref>, 'Step 1 (Ref. and Loc. Info)'!$..$33:$..$625, {2,3,5,8,9}, FALSE)
```

Step 4 self-populates five averages and five lookups from Step 1. Pasting over them
is what currently destroys them —
`fds_prep_for_submission_2023.Rmd:314` records having to "pull up the formulas for
averages" afterwards. The PSCIS side already applies the equivalent rule
(`0140_pscis_export_to_template.R:111`: "remove scoring columns, as these can't be
copied and pasted anyways because of macros").

**Open risk:** the template divides gradient by 100; our R column is
`average_gradient_percent` with no divisor. Percent vs proportion — a 100x
discrepancy if an R value is ever written into that cell. Tracked at fptr#217;
fastest check is against the submitted `PG24-879256_data.xls`.

## Which sites get submitted — settled, and the opposite of "withhold small sites"

Decision recorded in fptr#27, superseding earlier thinking in fptr#17:

> "we do not need to remove fish sampling sites just because they are small or
> update method_number… There is nothing wrong with accurate locational information
> for our little ef sites and all the detail on fish length weight and density
> linked to those locations. We just don't need the hab data submitted!"

So: submit every site's location (step_1) and all fish data (step_2, step_3); drop
only the `step_4_stream_site_data` habitat rows for the small nested `_ef` sites.
The 100 m threshold behind "conforming habitat site" traces to the RISC reconnaissance
standard — at least the greater of 100 m or 10x bankfull width — via
skeena_2023#84.

Implemented at `fds_prep_for_submission_2023.Rmd:292-309` as
`dplyr::filter(!grepl("ef", local_name))`. Note the predicate is a plain substring
match and would catch any `local_name` containing those letters.

Features are also trimmed: beaver dams and small LWD jams dropped, bridges removed
(those belong to PSCIS), remaining features need UTMs and height/length rounded to
the nearest metre (peace_2023#53, #62; skeena_2023#122).

## Fish data

`data/fish_data_tags_joined_2025.csv` — 97 records, 28 columns, all
`project_name = 2025-077-sern-peace-fish-passage`. 84 Rainbow Trout, 12 unidentified,
1 sucker.

2024 (`fish_data_tags_joined.csv`, 674 rows) shares an identical 28-column schema.
2023 does not — it uses `length_mm`/`weight_g` where later years use
`length`/`weight`. Reconciling that is crate#6 and is out of scope here.

Joining 2024 + 2025 on `pit_tag_id` (234 distinct tags) finds 6 tags recorded more
than once — four cross-year recaptures with a year of growth, two movements between
sites:

| PIT tag | Years | Site | Length mm | Weight g |
|---|---|---|---|---|
| `3DD.003E192A2C` | 2024→2025 | `125231_ds_ef2` → `125231_ds_ef1` | 89 → 143 | 8.3 → 31.9 |
| `3DD.003E192AD3` | 2024→2025 | `125179_us_ef1` | 94 → 135 | 9.3 → 24.2 |
| `3DD.003E192A33` | 2024→2025 | `125231_us_ef1` | 85 → 121 | 7.2 → 21.4 |
| `3DD.003E192ACB` | 2024→2025 | `125179_us_ef1` | 128 → 153 | 27.2 → 43.4 |
| `3DD.003E192AED` | 2024 | `125180_us_ef1` → `125179_ds_ef1` | 87 → 90 | 7.4 → 9.1 |
| `3DD.003E192A76` | 2025 | `198692_us_ef2` | 84 → 89 | 5.3 → 6.5 |

Not required for the submission, but a reportable effectiveness-monitoring result.
6/234 is a small rate — interpret cautiously until 2023 is joined.

## Programmatic population — feasible, deferred

Tested against the 2026 `.xlsx`:

- `openxlsx::loadWorkbook()` **fails** on the 2023 `.xls` (`subscript out of bounds`)
  and **succeeds** on the 2026 `.xlsx`
- load → `writeData()` → `saveWorkbook()` preserved validations, protection and
  formulas on 7 of 8 sheets; Step 2's validation count moved 33 → 35, likely
  range-splitting on re-serialize, **unconfirmed**
- LibreOffice round-trips `.xls ↔ .xlsx` losslessly (12 sheets, 101 validations,
  132,998 formulas, 17 definedNames all preserved) — useful for reading the legacy
  file, not needed once on `.xlsx`
- LibreOffice's bundled Python is SIGKILLed in the sandboxed session; the UNO path
  was not testable here

Deferred to fptr#216. This season's manual paste defines its spec.

## Script hygiene found while scoping

- `0210:35` calls `fpr::fpr_sp_gpkg_backup()` to no effect — return assigned to
  `form_fiss_site`, never read, overwritten at `:140`; `update_utm = TRUE` with
  `write_back_to_path = FALSE` discards the UTM update; the backup duplicates
  `0100_backup_forms.R`.
- `0210` is not standalone — uses `form_fiss_site_prep2` (`:52`, `:83`) without
  defining it; the object comes from `0205`'s environment.
- `0205_fiss_wrangle.R` is byte-identical (7246 B, md5 `a72d81d1…`) across
  template / peace_2025 / fraser_2025, as are `0210` (5830 B), `0220` (9320 B) and
  `fds_prep_for_submission_2023.Rmd` (14529 B). Fixes made here must be ported back
  or Fraser silently diverges — which is how peace_2024 and skeena_2024 ended up a
  generation apart.

## Related issues

| Issue | State | Relevance |
|---|---|---|
| fptr#215 | open | fish into `working.*` + parquet |
| fptr#216 | open | programmatic workbook generation |
| fptr#217 | open | gradient units |
| fptr#82 | open | 1:20k → 1:50k watershed codes, unported |
| fptr#27 | closed | the which-sites decision quoted above |
| fptr#156 | open | hybrid postgres + parquet storage architecture |
| dff-2022#94 | open | adopt the current template |
| dff-2022#96 | open | is `habitat_confirmations.xls` still needed |
| crate#6 | open | 2023 fish column reconciliation |
| fraser_2025_permit#3 | open | Fraser submission, Dec 31 |
