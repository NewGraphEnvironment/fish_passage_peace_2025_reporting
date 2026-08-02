# Prepare the Fish Data Submission sheets for the provincial permit submission.
#
# Consumes the four step CSVs produced by 0210_fiss_export_to_template.Rmd and
# 0220_fish_data_tidy.R, applies the submission-only transforms, and writes the
# result to data/permit_submission/. Nothing here touches the workbook - the
# outputs are what gets pasted into a copy of the blank provincial template.
#
# Supersedes fds_prep_for_submission_2023.Rmd for 2025. That script also rebuilt
# watershed codes and reference numbers because the 2023 workflow keyed off a
# hand-filled habitat_confirmations.xls; 0205/0210 now produce both upstream, so
# only the submission-shaping transforms remain.
#
# Usage (from repo root):
#   Rscript scripts/03_permit_submission/fds_prep_2025.R

suppressMessages({
  library(dplyr)
})

params <- rmarkdown::yaml_front_matter("index.Rmd")$params

dir_out <- fs::path("data/permit_submission")
fs::dir_create(dir_out)

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

# Reminder for the paste step -----------------------------------------------
#
# Step 4 self-populates five AVERAGE() and five VLOOKUP() columns - leave those
# alone, EXCEPT `Average Gradient (%)`. The template computes AVERAGE(...)/100,
# writing a proportion into a column headed (%) whose inputs are percents, so
# paste our average_gradient_percent over it. See
# fish_passage_template_reporting#217.
message(
  "\ngradient values to verify after pasting (percent, not proportion):\n",
  paste0(
    "  ", step_4_submission$local_name, ": ",
    ifelse(is.na(step_4_submission$average_gradient_percent), "-",
           step_4_submission$average_gradient_percent),
    collapse = "\n"
  )
)
