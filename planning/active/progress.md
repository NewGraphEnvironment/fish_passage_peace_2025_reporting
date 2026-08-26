# Progress — dead links in the results interactive map

## Session 2026-08-25

- Diagnosed both causes in published Peace 2025 and quantified them: 15 of 19 photo links dead, 34 `sum/` links dead
- Confirmed the mechanism live (404 on modelled-crossing id, 200 on PSCIS id)
- Established both defects exist in all four repos, and that the link block is byte-identical in template, Peace and Fraser
- Added the evidence to #61 rather than filing a duplicate — it was raised 2025-01-30 with the right diagnosis but hedged as "might be minor"
- Filed #231 (`docs/sum` never generated) and #232 (link check at build time)
- Archived the #23 FDS PWF, recording that the provincial submission is still outstanding
- Created branch `results-map-dead-links`
- Next: Phase 1 — build the link check so there is a red test before any fix

## Session 2026-08-26 — phases 1 to 5

- **Phase 1** link check built first, as a red test. DOM parsing alone found 2 of 51; leaflet popups are JSON inside a `<script>` tag. Added a raw pass. Commit `f15a8ca`
- **Phase 2** `photo_link` → `pscis_crossing_id`, clearing 15 dead links
- **Phase 3** `0190` gated on `update_html_map_tables`, keyed off the map objects, `docs/sum/` committed — 34 more. Found it could never have run: `pscis_all` is created nowhere in the reporting chain, and `fpr::fpr_table_cv_html()` reads its data from a global of that name. Commit `c5361a4`
- Check also surfaced four orphaned pages still being served (`ai-disclosure`, `changelog`, `attach-bayes`, `attach-maps`), dated 2026-05-19, no source, linking only to each other
- **51 → 0.** Check wired into `run_gitbook.R`; all three artifacts rebuilt; released 0.16.0. Commit `5103429`
- **Phase 4** Peace PR: `fish_passage_peace_2025_reporting#45`
- **Phase 5** ported to the template, released 0.17.0 there. Template PR `fish_passage_template_reporting#233`, closing #61, #231, #232
- Running the check against the template's own `docs/` found 47 broken links, including photo links pointing at Fraser's repo (#222). Not rebuilt there — that is #222's problem

## Next — Phase 6

Sync Fraser and Skeena from the template once #233 merges. Skeena's link block differs (`8cd061eb` vs `a655cb44`), so it needs one look rather than a straight copy. #230 rides along in that pass, promoting Skeena's region-generic eDNA map script.

Two things noted and deliberately not swept in:

- Peace's assistance note still reads "Claude Opus 4.7" at `index.Rmd:26`; Fraser, Skeena and the template have all dropped the model version
- The template's `docs/` renders as the Fraser report (#222)
