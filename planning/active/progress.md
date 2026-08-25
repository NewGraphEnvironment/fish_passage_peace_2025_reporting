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
