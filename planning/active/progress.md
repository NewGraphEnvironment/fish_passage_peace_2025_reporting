# Progress — Repair bib citation key drift (#7)

## Session 2026-05-05

- Plan-mode exploration via Explore agent: confirmed all 25 missing keys exist in BOTH xciter's canonical bib AND Peace's references.bib; rbbt error is "missing-from-Zotero" not "missing-from-bib"; xciter canonical was last refreshed Jan 16 (4 months stale)
- Plan approved with Phase 0 (refresh xciter canonical) added as prerequisite to avoid mapping prose to stale canonical
- Created branch `7-bib-repair` off main
- Scaffolded PWF baseline with approved phases
- **Phase 0 done**: wrote `xciter/scripts/refresh_canonical_bib.R`, refreshed canonical from Zotero (1321→1560 entries, +239), committed xciter@8d5f300
- **Phase 1 done**: SQLite-based key triage (libs 1+9, 2253 items dumped) resolved 23 canonical replacements + identified 7 software refs as false positives (rbbt resolves them; refresh script bug: `item.search(' ')` skips no-whitespace items)
- **Phase 3 done early**: 2 `&`-blocked keys fixed at Zotero source — pinned clean keys via JS console (`item.setField + saveTx + KM.store`); BBT's `KM.update(item, {replace: true})` did NOT re-pin from Extra in our testing. Updated `citekeyFormat` pref to strip `&` going forward. Refreshed xciter canonical again — clean keys landed.
- **Phase 2 done**: 29 prose replacements across 6 Rmd files (0100-intro, 0200-background, 0300-methods, 0400-results, index). `bbt_write_bib()` now resolves all 84 cites (0 missing).
- Next: commit Phase 2/3, refresh xciter commit (canonical bib delta), Phase 4 — flip `update_bib: TRUE` and verify build
