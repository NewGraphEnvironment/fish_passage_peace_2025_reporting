# Task: Repair bib citation key drift (#7)

Peace's prose cites 25 citation keys that no longer exist in the live NGE Zotero library. `rbbt::bbt_write_bib()` errors with "not found: …" listing all 25. Worked around in v0.1.0 with `update_bib: FALSE`. Goal: replace stale prose keys with current canonical keys, then flip `update_bib: TRUE` so future drift is caught at build time.

Approach: 2-pass recipe from `restoration_wedzin_kwa_2024/scripts/bib_repair.R` (manual xref overrides + fuzzy match + bulk replace), preceded by a Phase 0 to refresh xciter's stale (4-month-old) canonical bib from current Zotero state.

## Phase 0: Refresh xciter's canonical bib

Lives in xciter (`~/Projects/repo/xciter/`). One-shot ad-hoc script — keep simple per user direction.

- [ ] Verify Zotero is running locally with Better BibTeX add-on active
- [ ] Write `xciter/scripts/refresh_canonical_bib.R` that:
  - Connects to local BBT JSON-RPC endpoint
  - Pulls full library export in BibTeX format
  - Writes to `xciter/inst/extdata/NewGraphEnvironment.bib`
  - Prints before/after entry counts for sanity check
- [ ] Run script, verify output (entry count vs previous, file size, recent timestamps)
- [ ] Commit + push xciter
- [ ] In Peace's R env: `pak::pak("NewGraphEnvironment/xciter")`

## Phase 1: Triage Peace's 25 missing keys against fresh canonical

Read-only investigation. No prose changes yet.

- [x] Run `xciter::xct_bib_keys_missing()` on Peace's `*.Rmd` citations vs fresh canonical → 32 keys flagged
- [x] Used SQLite-based zotero-lookup (libs 1+9 dump) to resolve canonicals — better than fuzzy match
- [x] Categorize keys into buckets:
  - **(A) Found exact-match in Zotero** — 7 software refs (rbbt resolves them; my refresh script's `item.search(' ')` enumeration silently skipped no-whitespace items)
  - **(B) Renamed canonical in Zotero** — 23 keys with high-confidence canonical replacements
  - **(C) `&`-blocked** — 2 keys (BC Species Explorer, WA Dept Fish&Wildlife) — fixed at the Zotero source by pinning clean keys via JS console
- [x] Presented resolution table — user approved

## Phase 2: Apply replacements (with explicit checkpoint)

- [x] Built `(key_missing, key_match)` pair list — 23 pairs
- [x] **DRY-RUN** — 29 replacements across 6 Rmd files previewed, user-visible before write
- [x] Applied via R `stringr::str_replace_all` with pandoc-aware lookahead `(?![A-Za-z0-9:._+/\\-])`
- [x] `bbt_write_bib()` now resolves all 84 cites (80 entries written, 0 missing)
- [ ] Single commit per replacement batch so git diff shows exactly what changed

## Phase 3: Address `&`-blocked keys (formerly bucket C)

- [x] Pinned clean keys on 3 Zotero items via JS console (`item.setField + saveTx + KM.store`)
- [x] Updated BBT `citekeyFormat` pref to strip `&` from future auto-generated keys
- [x] Re-ran `refresh_canonical_bib.R` — old `&` keys gone, new clean keys present
- [ ] Draft upstream BBT issue for default `&`-strip + `KeyManager.update` re-pin behavior

## Phase 4: Flip `update_bib: TRUE` and verify

- [ ] Edit `index.Rmd` params: `update_bib: FALSE` → `TRUE`
- [ ] Run `Rscript scripts/run_gitbook_iter.R`
- [ ] Verify build succeeds (251/251 chunks, no rbbt error)
- [ ] If still failing: loop back to Phase 3
- [ ] If clean: commit toggle + rebuilt `docs/` + regenerated `references.bib`

## Phase 5: Validation + ship

- [ ] `/code-check` on cumulative branch diff
- [ ] PWF checkboxes match landed work
- [ ] `/planning-archive`
- [ ] `/gh-pr-push` with cross-ref to xciter refresh commit + closes #7

## Decisions made

| Decision | Rationale |
|---|---|
| Phase 0 first (refresh canonical) | Avoid chasing moving target — mapping prose to stale canonical risks replacing one missing-from-Zotero key with another |
| Refresh script in xciter `scripts/` (not function) | "Don't worry on scheduling, keep simple" — promote to package function later if reused |
| Per-repo bib repair script (not skill yet) | Per user: "maybe a skill after we're done. don't really care." Promote to skill once 3rd repo needs it |
| Single commit per replacement batch | Clean git diff for review/audit |

## Notes

- `data/bcfishpass.sqlite` and `data/inputs_extracted/fiss_species_table.csv` are intentionally not committed (build noise per established pattern)
