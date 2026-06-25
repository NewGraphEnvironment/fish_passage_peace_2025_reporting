# Progress — #34 link Parsnip vignette → appendix

## Session 2026-06-25

- Filed [Peace #34](https://github.com/NewGraphEnvironment/fish_passage_peace_2025_reporting/issues/34) — scope: port `link` `pars-habitat-connectivity.Rmd` to a Peace appendix via `/vignette-to-appendix`, cross-ref from Methods + Results.
- Got `~/Projects/repo/link` onto `main` (@ 29e3e92, v0.43.0); verified vignette + `inst/vignette-data/{pars.gpkg,pars_parity.rds}` present. Local log-csv change stashed at `link` `stash@{0}` (restore on branch `196-streams-access-source-flags`).
- Read the source vignette in full; captured structure, figures, parity counts, and body cross-ref insertion points in findings.md.
- Branched Peace `34-vignette-appendix` off main.
- Archived stale `planning/active/` (completed-but-unarchived issue #24 monitoring appendices) → `planning/archive/2026-06-issue-24-monitoring-appendices/` with outcome README.
- Scaffolded #34 PWF baseline (task_plan, findings, progress).
- **Next:** Phase 1 — run `/vignette-to-appendix` report-only and review the draft; decide appendix slot (`07X0` group) + gpkg commit-vs-gitignore.
