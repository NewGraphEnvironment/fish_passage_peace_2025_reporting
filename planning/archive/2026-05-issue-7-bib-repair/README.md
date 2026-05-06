# Repair bib citation key drift (#7)

**Outcome:** v0.1.1 ships with `update_bib: TRUE` and 0 missing keys. Future Zotero drift will fail loud at build time.

**What landed:**
- 23 prose citation key replacements across 5 Rmd files (Peace `b95641e`)
- 2 `&`-blocked keys fixed at the Zotero source by pinning clean variants via JS console (`item.setField + saveTx + KM.store` — BBT's documented `KM.update(item,{replace:true})` did NOT honour Extra-pin in our BBT 6.7.x)
- BBT `citekeyFormat` pref locally patched to strip `&` from future auto-generated keys (tracked in personal memory: `reference_bbt_doctored_pref.md`)
- xciter canonical bib refreshed twice (`8d5f300` + `f936e56`) — Phase 0 baseline + post-rename
- 23 Peace bib_repair pairs added to `xciter/inst/extdata/xct_xref_citations_match.csv` for Skeena/Fraser/restoration reuse
- Upstream BBT search documented in [xciter#5](https://github.com/NewGraphEnvironment/xciter/issues/5): maintainer's stable position is "use a custom citekey pattern, won't change defaults" (#602, 2016) — no PR worth filing

**Closing PR:** TBD (Peace branch `7-bib-repair`)

**Related:**
- xciter#5 — upstream prior-art parking + reproduction recipe for new teammates
- BBT prior art: retorquere/zotero-better-bibtex#602, #659, #941

**Side findings filed for separate work:**
- `scripts/refresh_canonical_bib.R` uses `item.search(' ')` for enumeration — silently skips no-whitespace items (software refs missed)
- BBT `KM.update(item, {replace: true})` not re-pinning from Extra in BBT 6.7.x deserves minimal repro before deciding whether to file upstream
