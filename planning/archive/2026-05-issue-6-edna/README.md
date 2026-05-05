# Issue #6 — Integrate eDNA results into Peace 2025 report

## Outcome

Integrated UNBC 2025 eDNA results into the Peace report as a hybrid placement following the wedzin_kwa narrative-first pattern: short Results subsection (per-species summary table) in `0400-results.Rmd`, full detail in a new thematic appendix `0850-appendix-edna.Rmd` (per-site detection table, field blanks table, retests table), and brief per-crossing mentions in the 3 existing per-site appendices (199663, 203597, 203605). Self-containment principle held: Peace builds from `git clone` with no cross-repo runtime deps. Snapshot script (`scripts/edna_inputs_snapshot.R`) pulls analytic CSVs from the upstream template repo and pins the version via a manifest with the upstream commit SHA + per-file md5. Peace-only interactive map (`scripts/edna_map_peace.R`) filters by source and exposes a Controls layer (off by default) for field blanks with explicit "FIELD BLANK — protocol QA, not site eDNA" framing. Both gitbook and pagedown PDF builds verified end-to-end.

Five upstream commits in `fish_passage_template_reporting` were required to enable Peace's filter/labelling: form-backup script bug fixes (skip non-form gpkgs, drop sf geometry before write_excel_csv), M41351 form correction propagation, `source` column carry-through to analytic CSVs, and `control_blank_field/office/species_present_field` carry-through to rollups.

Side issues filed during the work:
- `fish_passage_peace_2025_reporting#7` — bibliography citation-key drift (25 keys re-keyed in Zotero, prose not updated). Worked around with `update_bib: FALSE` in `index.Rmd`; xciter-based repair recipe captured.
- Pre-existing template-spawn drift: `_bookdown.yml` `book_filename` is the template name not Peace's. Iter scripts read both and use each appropriately. To clean up separately.

Generalizable learnings worth promoting later (not into CLAUDE.md right now — `/claude-md-propagate` next time the same gotcha recurs):
- `on.exit()` at top-level Rscript silently no-ops; wrap in a function so it attaches to a frame.
- `mapply(file.rename, ...)` silently no-op'd in practice on at least one run; defensive per-file loop with cat-reporting is more robust.
- `readr::write_excel_csv` (2.2.0) trips on sticky `sfc_POINT` geometry columns; drop geometry before write.
- The snapshot+manifest pattern (`scripts/edna_inputs_snapshot.R`) is a clean way to handle cross-repo data deps without runtime path coupling — pin upstream commit + per-file md5 in a committed manifest.

Closed by: commit `a94caba` (latest on `6-edna` at archive time) / PR #TBD
