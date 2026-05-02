# Task: Integrate eDNA results into Peace 2025 report (#6)

eDNA UNBC 2025 batch results need to be integrated into Peace's Results chapter + a new thematic appendix + brief mentions in 3 per-site appendices, rendering correctly in BOTH the gitbook (HTML) and pagedown (Chrome PDF) builds. Peace must build cleanly from `git clone` — no cross-repo runtime dependencies, no runtime dependency on m1rr0r.

## Phase 1: Snapshot data + Peace-local map build

- [ ] Copy `data/edna_unbc_results_2025_analytic.csv` from template repo into Peace `data/`
- [ ] Copy `data/edna_unbc_results_2025_by_site_target.csv` from template repo into Peace `data/`
- [ ] Identify Peace site filter (drive from `params$wsg_code` in `index.Rmd`)
- [ ] Create `scripts/edna_map_peace.R`:
  - Reads local CSVs
  - Filters to Peace sites (`wsg_code` based)
  - Produces `data/edna_unbc_results_2025_peace_map.html`
  - Header documents refresh procedure (no README until pattern reused)
- [ ] Run script, verify output map opens locally + shows only Peace sites

## Phase 2: Main Results subsection (gitbook + PDF dual)

- [ ] Verify Methods eDNA section in `0300-methods.Rmd` (lines 391-416) — should be unchanged, just confirm
- [ ] Replace `INCLUDE LAB RESULTS` stub in `0400-results.Rmd` with eDNA subsection:
  - 1-2 paragraph narrative (sites tested, headline findings)
  - High-level summary table chunk (sites × species, confirmed/not detected counts)
    - DT interactive for `gitbook_on = TRUE`
    - `fpr_kable` static for PDF
  - Link to thematic appendix
  - Link to Peace map (path/URL strategy depending on output)
  - Prose adapts to format (no "interactive map below" language in PDF)

## Phase 3: Thematic appendix `08xx-Appendix-edna.Rmd`

- [ ] Pick the appendix number (consistent with existing convention; check what `08xx` slot is free)
- [ ] Create file with structure:
  - Per-site detection table (Peace-filtered)
  - Per-species detection rollup
  - QA / retest summary
  - Link to Peace map
- [ ] Each table chunk dual-gates gitbook/PDF (DT vs kable)
- [ ] Add to `_bookdown.yml` rmd_files order
- [ ] Verify rendering in both formats

## Phase 4: Per-site appendix mentions

For the 3 existing per-site appendices, add brief eDNA subsection IF the site was sampled:

- [ ] `0800-appendix-199663-trib-to-parsnip.Rmd` — eDNA subsection if applicable
- [ ] `0800-appendix-203597-trib-to-nation.Rmd` — same
- [ ] `0800-appendix-203605-trib-to-willis-res.Rmd` — same

## Phase 5: Validation

- [ ] Peace builds from `git clone` with no cross-repo path dependencies
- [ ] Map script generates Peace-only map cleanly
- [ ] gitbook build (`gitbook_on = TRUE`): Results subsection renders with interactive table + working link to map; thematic appendix renders; per-site appendix mentions render
- [ ] pagedown PDF build (`gitbook_on = FALSE`): Same content renders with static tables, no "interactive" language, URLs visible
- [ ] `/code-check` clean on each commit
- [ ] PWF checkboxes match landed work
- [ ] `/planning-archive` on completion → `/gh-pr-push`

## Key Questions

1. Which `08xx-Appendix-*.Rmd` slot is free for the eDNA thematic appendix? (Peace already has 3 per-site appendices at 0800-appendix-{site_id}; thematic needs to slot somewhere that doesn't collide)
2. How does the Peace map file get linked from the report — by relative path inside published gitbook, or by configured URL? (decide during Phase 1 once publishing target is confirmed)
3. Do all 3 per-site appendix sites have eDNA samples? (verify in Phase 1, adjust Phase 4 scope if any have no samples)

## Decisions Made

| Decision | Rationale |
|----------|-----------|
| Hybrid placement (Results narrative + thematic appendix + per-site mentions) | Lifts wedzin kwa narrative-first pattern; preserves detail in appendix |
| Data flow option B: snapshot CSVs into Peace | Repos must stand alone from `git clone` |
| Peace builds its own map locally (not link to m1rr0r combined map) | Self-containment + m1rr0r is interim hosting only |
| Pipeline source-of-truth stays in template repo | First-year UNBC results, prove pattern before crate migration |
| Branch: `6-edna` | User pattern: `<issue#>-<topic>` |

## Errors Encountered

| Error | Attempt | Resolution |
|-------|---------|------------|
|       | 1       |            |

## Notes

- Each phase ends with an atomic commit bundling code + checkbox flip in this file
- Don't merge phases — multi-PR ship per user direction
- Methods section is already in place and generic; do not edit unless verification reveals a problem
- Permanent publishing host (replacing m1rr0r) is out of scope here, tracked separately
