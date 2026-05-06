# Findings — Repair bib citation key drift (#7)

## Issue context

The bookdown build errors when `update_bib: TRUE` (the default before issue #6 added the gate) because `rbbt::bbt_write_bib()` finds 25 citation keys in the Rmd prose that no longer exist in our Zotero library. Likely cause: those keys got renamed in Zotero (Better BibTeX auto-rekey) at some point, but the `@citekey` references in the Rmd files were never updated to match.

Working around with `update_bib: FALSE` for now (uses the committed `references.bib` which still has these keys), but that means the bib doesn't refresh from Zotero on builds — masks any future drift.

## Missing keys (from 2026-05-04 build attempt with `update_bib: TRUE`)

```
busch_etal2011LandscapeLevelModela
swalesRoleOffChannelPonds1989
slaneyFishHabitatRehabilitation1997
data_fish_obs
hagen_2015_critical_habs
bull_trout_synthesis
bt_cosewic
bcspeciesecosystemexplorer2020Salvelinusconfluentus
anzac_sens
hominka_sens
table_sens
missinka_sens
fsw_order
hagenTrendAbundanceArctic2018
williamson_2004
stewartFishLifeHistory2007
clarkinNationalInventoryAssessment2005
bellFisheriesHandbookEngineering1991
thompsonAssessingFishPassage2013
ProvincialObstaclesFish
flnrordForestTenureRoad2020
flnrordDigitalRoadAtlas2020
confirmation_checklist_2011
resourcesinventorycommittee2001Reconnaissance20a
washingtondepartmentoffishwildlife2009FishPassage
```

Mix of legacy snake_case keys (`data_fish_obs`, `bt_cosewic`) and BBT auto-generated camelCase keys that may have since been re-keyed in Zotero.

## Exploration findings (2026-05-05)

- **All 25 missing keys ARE in xciter's canonical `NewGraphEnvironment.bib`** — but the canonical was last refreshed `2026-01-16` (4 months stale). It's a manual export from Zotero with no automated sync. Risk: mapping to a stale canonical means we might replace one missing-from-Zotero key with another missing-from-Zotero key.
- **All 25 missing keys ARE in Peace's `references.bib`** (committed, 84 entries, 50KB) — that's why the build works with `update_bib: FALSE`.
- **xciter's xref CSV (`xct_xref_citations_match.csv`) is restoration_wedzin_kwa_2024-specific**: only 5 rows, none of Peace's 25 keys are in it. Per file comment "we have mismatches that we need to fix custom" — this is reactive per-repo curation, not a universal NGE list.
- **rbbt error semantics**: `bbt_write_bib()` queries Zotero via Better BibTeX JSON-RPC. "Not found" means missing-from-Zotero, not missing-from-references.bib.
- **Peace R env**: xciter 0.0.0.9001, rbbt 0.0.0.9000, ngr 0.0.1 — all dev versions, all installed.

## Implication for plan

Phase 0 (refresh xciter's canonical bib) must happen FIRST so the bib_repair recipe maps to current Zotero state, not the January snapshot.

## Resources

- Recipe model: `~/Projects/repo/restoration_wedzin_kwa_2024/scripts/bib_repair.R`
- xciter package: `~/Projects/repo/xciter/`
- xciter canonical bib: `~/Projects/repo/xciter/inst/extdata/NewGraphEnvironment.bib`
- xciter xref CSV: `~/Projects/repo/xciter/inst/extdata/xct_xref_citations_match.csv`
- Peace's references.bib: `~/Projects/repo/fish_passage_peace_2025_reporting/references.bib`
- BBT JSON-RPC endpoint: `http://localhost:23119/better-bibtex/json-rpc`
