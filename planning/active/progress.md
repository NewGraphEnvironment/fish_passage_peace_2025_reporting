# Progress — Repair bib citation key drift (#7)

## Session 2026-05-05

- Plan-mode exploration via Explore agent: confirmed all 25 missing keys exist in BOTH xciter's canonical bib AND Peace's references.bib; rbbt error is "missing-from-Zotero" not "missing-from-bib"; xciter canonical was last refreshed Jan 16 (4 months stale)
- Plan approved with Phase 0 (refresh xciter canonical) added as prerequisite to avoid mapping prose to stale canonical
- Created branch `7-bib-repair` off main
- Scaffolded PWF baseline with approved phases
- Next: Phase 0 — write `xciter/scripts/refresh_canonical_bib.R`, run, commit + push xciter, reinstall in Peace env
