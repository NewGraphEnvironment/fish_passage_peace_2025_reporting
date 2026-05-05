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

- [ ] Run `xciter::xct_bib_keys_missing()` on Peace's `*.Rmd` citations vs fresh canonical
- [ ] For each remaining missing key, run `xct_keys_guess_match(stringdist_threshold = 25)`
- [ ] Categorize 25 keys into 3 buckets:
  - **(A) Direct match** — present in fresh canonical, no replacement needed
  - **(B) Fuzzy candidate** — different key in canonical that's clearly the same reference
  - **(C) Truly missing** — not in fresh canonical even by fuzzy match
- [ ] Present triage table for user approval before any prose edits

## Phase 2: Apply replacements (with explicit checkpoint)

- [ ] For bucket (B) approved fuzzy matches: build `(key_missing, key_match)` pair list
- [ ] **DRY-RUN first** — print every planned replacement (file, line, before/after) without applying
- [ ] After user inspection, apply via `ngr::ngr_str_replace_in_files()` across Peace's `*.Rmd`
- [ ] Filter out NA-match rows defensively (recipe has known bug with NA mapping)
- [ ] Single commit per replacement batch so git diff shows exactly what changed

## Phase 3: Address bucket (C) — truly missing keys

- [ ] Decide per key: (i) add to Zotero, (ii) accept it lives only in committed `references.bib` and document, (iii) remove citation from prose if no longer needed
- [ ] Apply chosen fix per key

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
