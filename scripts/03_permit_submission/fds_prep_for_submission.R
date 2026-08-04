# Prepare the Fish Data Submission sheets for the provincial permit submission.
#
# Consumes the four step CSVs produced by 0210_fiss_export_to_template.Rmd and
# 0220_fish_data_tidy.R, applies the submission-only transforms, and writes the
# result to data/permit_submission/. Nothing here touches the workbook - the
# outputs are what gets pasted into a copy of the blank provincial template.
#
# Usage (from repo root):
#   Rscript scripts/03_permit_submission/fds_prep_for_submission.R
#
# ---------------------------------------------------------------------------
# MANUAL STEPS AROUND THIS SCRIPT
# ---------------------------------------------------------------------------
#
# 1. Copy the blank template to data/permit_submission/<permit_id>.xlsx.
#    Blank lives at data/templates/FDS_Template2026-03-11.xlsx.
#
# 2. Fill the Step 1 header block by hand:
#      Project Title              same as the report title
#      Company/Agency             Other
#      Company/Agency (Other)     New Graph Environment Ltd.
#      Spreadsheet Recorder(s)    whoever assembled it
#      Project Type               Research
#      PROVINCIAL PERMIT NUMBER   params$permit_id
#      Reviewed and verified by a Registered Professional Biologist    Yes
#      Biologist's Name           Allan Irvine
#      Registration Number        2775
#      Province of Registration   British Columbia
#
# 3. Run this script, then paste the four CSVs in. Data starts at rows
#    33 / 25 / 20 / 22 for Steps 1-4.
#
#    Step 4 self-populates five AVERAGE() and five VLOOKUP() columns - leave
#    those alone, EXCEPT `Average Gradient (%)`. See the note at the foot of
#    this script.
#
# 4. QA. The provincial QA tool ships in the same zip as the template and runs
#    only on Windows, Excel 2010 or earlier. It is optional but recommended.
#    The historical route is: copy the workbook to OneDrive, open on a Windows
#    machine, run the tool, record issues, copy back. Anything fixed there must
#    be fixed in the repo copy too or the two diverge.
#
# 5. Submit via the WLRS SPO FDS SharePoint site
#    (https://bcgov.sharepoint.com/sites/WLRS-FDS; access via
#    fishdatasub@gov.bc.ca), plus DFO if the permit requires it. Capture the
#    confirmation in the repo.
#
# ---------------------------------------------------------------------------
#
# Replaces fds_prep_for_submission_2023.Rmd. That version also rebuilt watershed
# codes and reference numbers because the 2023 workflow keyed off a hand-filled
# habitat_confirmations.xls; 0205/0210 now produce both upstream, so only the
# submission-shaping transforms remain here. Its per-season values are in git
# history rather than duplicated in a second file - the year in that filename is
# what let it be copied forward into the 2024 and 2025 repos unchanged.

suppressMessages({
  library(dplyr)
})

params <- rmarkdown::yaml_front_matter("index.Rmd")$params

dir_out <- fs::path("data/permit_submission")
fs::dir_create(dir_out)

# Where the built workbook lands.
#
# Defaults to hold/ so a draft can be reviewed before it becomes the submission
# artifact. Once the draft is confirmed good, flip to the submission dir and
# re-run - it overwrites in place.
dir_workbook <- fs::path("hold")
# dir_workbook <- dir_out   ## <- flip when the draft has been reviewed

path_workbook <- fs::path(dir_workbook, paste0(params$permit_id, ".xlsx"))
path_template <- fs::path("data/templates/FDS_Template2026-03-11.xlsx")

rd <- function(p) readr::read_csv(p, show_col_types = FALSE)

step_1 <- rd("data/inputs_extracted/form_fiss_loc_tidy.csv")
step_2 <- rd("data/inputs_raw/fish_data_coll.csv")
step_3 <- rd("data/inputs_raw/fish_data_ind.csv")
step_4 <- rd("data/inputs_extracted/form_fiss_site_tidy.csv")

# Which sites are small electrofishing sites -------------------------------
#
# Site naming is <crossing_id>_<location>_ef<n>. The 2023 script used
# grepl("ef", local_name), a bare substring match that would also catch any name
# happening to contain those letters. Anchor it instead.
is_ef <- function(x) grepl("_ef[0-9]*$", x)

stopifnot(sum(is_ef(step_4$local_name)) > 0)

# step_4 - carry the site id into comments, then drop the ef sites -----------
#
# Per fish_passage_template_reporting#27: locations and all fish data for the
# small ef sites are submitted; only their habitat rows are withheld, because a
# return-visit shocking site is not a conforming 100 m habitat site (RISC recce
# standard - at least the greater of 100 m or 10x bankfull width).
#
# The alias is moved into comments first so the province's copy can still be
# cross-referenced back to our reports.
step_4_commented <- step_4 |>
  mutate(
    comments = dplyr::case_when(
      is.na(comments) | !nzchar(trimws(comments)) ~ paste0("Site ", local_name, "."),
      TRUE ~ paste0("Site ", local_name, ". ", comments)
    )
  )

step_4_submission <- step_4_commented |>
  filter(!is_ef(local_name))

# step_2 - inherit the comments from the dropped step_4 rows -----------------
#
# Once the ef rows leave step_4, step_2 is the only sheet carrying their
# comments, so append them there rather than lose them.
comments_from_step_4 <- step_4_commented |>
  select(reference_number, comments_site = comments)

step_2_submission <- step_2 |>
  left_join(comments_from_step_4, by = "reference_number") |>
  mutate(
    comments = dplyr::case_when(
      is.na(comments_site) ~ comments,
      is.na(comments) | !nzchar(trimws(comments)) ~ comments_site,
      TRUE ~ paste(comments_site, comments)
    )
  ) |>
  select(-comments_site)

# step_1 and step_3 pass through unchanged - every site's location is
# submitted, and so is every fish.
step_1_submission <- step_1
step_3_submission <- step_3

# Write ---------------------------------------------------------------------
readr::write_csv(step_1_submission, fs::path(dir_out, "step_1_ref_and_loc_info.csv"), na = "")
readr::write_csv(step_2_submission, fs::path(dir_out, "step_2_fish_coll_data.csv"), na = "")
readr::write_csv(step_3_submission, fs::path(dir_out, "step_3_individual_fish_data.csv"), na = "")
readr::write_csv(step_4_submission, fs::path(dir_out, "step_4_stream_site_data.csv"), na = "")

message(
  "permit ", params$permit_id, " - rows to paste:\n",
  "  step_1 ", nrow(step_1_submission), " (all sites)\n",
  "  step_2 ", nrow(step_2_submission), "\n",
  "  step_3 ", nrow(step_3_submission), " (all fish)\n",
  "  step_4 ", nrow(step_4_submission), " of ", nrow(step_4),
  " (dropped ", sum(is_ef(step_4$local_name)), " ef sites)"
)

# Build the workbook --------------------------------------------------------
#
# Writes the four sheets into a copy of the blank provincial template, so no
# copy-paste-special is required. The CSVs above remain the reviewable
# intermediate, and still support the manual route if this is ever distrusted.
#
# One rule, enforced by `col_skip` below: derived columns are left alone so the
# workbook computes them itself - the VLOOKUP pulls from Step 1 on every sheet,
# Step 2's Soak Time, and all five of Step 4's AVERAGE columns.
#
# That includes `Average Gradient (%)` (Step 4, col 44), whose formula is
# AVERAGE(...)/100. The /100 is correct and must not be overridden: that cell
# carries Excel number format `0.0%`, and a percent-formatted cell multiplies by
# 100 for display. So 0.028 displays as 2.8%, which is what the measurements
# (2.0, 3.5, ...) average to. Writing 2.8 into it would display as 280.0%.
# See fish_passage_template_reporting#217.

sheet_spec <- list(
  list(sheet = "Step 1 (Ref. and Loc. Info)",   row_header = 32, dat = step_1_submission, col_skip = integer(0)),
  list(sheet = "Step 2 (Fish Coll. Data)",      row_header = 24, dat = step_2_submission, col_skip = c(2:6, 31)),
  list(sheet = "Step 3 (Individual Fish Data)", row_header = 19, dat = step_3_submission, col_skip = c(2:6)),
  list(sheet = "Step 4 (Stream Site Data)",     row_header = 21, dat = step_4_submission, col_skip = c(2:6, 14, 23, 32, 38, 44))
)

# 0210 builds step_1 and step_4 by binding onto the template's own empty sheet,
# so their names already match. 0220 does not, so the fish sheets need a map
# from our column name to the template's. Folding that into 0220 would delete
# this - see fish_passage_template_reporting#216.
col_rename <- list(
  "Step 2 (Fish Coll. Data)" = c(
    haul_number_pass_number = "pass_number", ef_length_m = "site_length",
    ef_width_m = "avg_wetted_width_m", stage = "life_stage",
    total_number = "total_num", min_length_mm = "min_length",
    max_length_mm = "max_length"),
  "Step 3 (Individual Fish Data)" = c(
    haul_number_pass_number = "pass_number", length_mm = "length",
    weight_g = "weight")
)

fs::dir_create(dir_workbook)
cells <- tidyxl::xlsx_cells(path_template)
wb <- openxlsx::loadWorkbook(path_template)

for (sp in sheet_spec) {
  hdr <- cells |>
    filter(sheet == sp$sheet, row == sp$row_header, !is.na(character)) |>
    arrange(col)
  nms <- janitor::make_clean_names(trimws(hdr$character))
  map <- col_rename[[sp$sheet]]

  for (i in seq_len(nrow(hdr))) {
    if (hdr$col[i] %in% sp$col_skip) next
    nm <- nms[i]
    if (!is.null(map) && nm %in% names(map)) nm <- unname(map[[nm]])
    if (!nm %in% names(sp$dat)) next   # field we do not collect - left blank
    openxlsx::writeData(wb, sheet = sp$sheet, x = sp$dat[[nm]],
                        startRow = sp$row_header + 1, startCol = hdr$col[i],
                        colNames = FALSE)
  }
}

openxlsx::saveWorkbook(wb, path_workbook, overwrite = TRUE)
message("\nworkbook written: ", path_workbook,
        if (identical(as.character(dir_workbook), "hold")) "  (DRAFT - review, then flip dir_workbook)" else "")
# Gaps worth seeing before the workbook is reviewed -------------------------
#
# Sites whose watershed code did not resolve. Some crossings have no entry in
# whse_basemapping.fwa_streams_20k_50k, so the 20k -> 50k cross-reference
# returns nothing and both the code and the waterbody id are missing. These
# need a manual lookup - the documented route is QA in QGIS against
# whse_fish.wdic_waterbody_route_line_svw.
gaps <- step_1_submission |>
  filter(is.na(watershed_code_45_digit) | is.na(waterbody_id_identifier)) |>
  select(alias_local_name, waterbody_id_identifier, watershed_code_45_digit)

if (nrow(gaps) > 0) {
  message("\n!! ", nrow(gaps), " of ", nrow(step_1_submission),
          " sites are missing a watershed code / waterbody id:")
  message(paste0("     ", gaps$alias_local_name, collapse = "\n"))
} else {
  message("\nall sites carry a watershed code and waterbody id")
}
