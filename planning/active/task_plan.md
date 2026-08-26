# Task: Dead links in the results interactive map

Work happens here first because **the template has no field data** — Peace has real data and a really broken map, so it is the only place the fix can be verified. Once green here it goes straight into the template, and Fraser and Skeena are synced from there rather than hand-edited.

The issues live in `fish_passage_template_reporting`:

| Issue | Symptom | Scale in Peace |
|---|---|---|
| [#232](https://github.com/NewGraphEnvironment/fish_passage_template_reporting/issues/232) | Nothing checks that rendered links resolve | — |
| [#61](https://github.com/NewGraphEnvironment/fish_passage_template_reporting/issues/61) | `photo_link` built from `my_crossing_reference`, not `pscis_crossing_id` | 15 of 19 dead |
| [#231](https://github.com/NewGraphEnvironment/fish_passage_template_reporting/issues/231) | `sum/cv/` + `sum/bcfp/` pages never generated | 34 dead |
| [#230](https://github.com/NewGraphEnvironment/fish_passage_template_reporting/issues/230) | eDNA map script: same `update_*` switch pattern as #231 | — |

## Phase 1: Link check first (#232)

Built before the fixes so there is a red test to fix against — otherwise "fixed" means "I clicked a few and they looked fine".

- [x] Script that walks rendered `docs/**/*.html`, extracts `href`/`src`
- [x] Repo-relative links: assert the file exists **and is tracked by git** (untracked is the eDNA-map failure — present locally, absent on the published site)
- [x] `raw.githubusercontent.com` links into this repo: resolve to a repo path and check the same way, offline
- [x] External links: opt-in only, off by default, so the check stays fast and deterministic
- [x] Reports page + href for every failure, exits non-zero
- [x] **Confirm it fails on Peace as it stands, reporting the 15 photo and 34 `sum/` links**

## Phase 2: Photo links (#61)

- [x] Point `photo_link` at `pscis_crossing_id` in `scripts/02_reporting/0130-tables.R`
- [x] Keep the caveat recorded in #61: crossing details must still reach an appendix, and reassessment data must not end up in a report appendix where it does not belong
- [x] Rebuild; link check clears the 15 photo failures

## Phase 3: Culvert + model pages, and the eDNA map (#231, #230)

Both want the same switch — design it once.

- [x] Add an `update_*` switch to `index.Rmd` following `update_bcfishpass`
- [x] Gate `scripts/02_reporting/0190-build-html-map-tables.R` on it
- [x] Reconsider `0190`'s unconditional `fs::file_delete()` — with output committed, deleting before a run that then fails leaves the repo worse than before it started
- [x] Commit `docs/sum/`
- [ ] ~~Same switch for the eDNA map script~~ — **moved to Phase 5.** Peace's `edna_map_peace.R` is a Peace-hardcoded lineage (376 lines) while Skeena's `edna_map.R` is already region-generic (418). Consolidating in the template, with Skeena's as the base, avoids creating a fifth variant of the script we are trying to unify.
- [x] Rebuild; link check green

## Phase 4: Release Peace

- [x] Bump to 0.16.0 with NEWS
- [x] Rebuild gitbook + PDF + executive summary PDF
- [x] Verify published links resolve from a fresh clone, not just locally

## Phase 5: Port to the template

The link block is byte-identical in template, Peace and Fraser (`a655cb44`), so this is a clean transplant.

- [x] Port all three fixes plus the link check
- [x] Wire the check into `run_gitbook.R` so it runs unprompted
- [x] PR closing #61, #231, #232 (template PR #233). **#230 stays open** — the template has no eDNA map link or region-scoped script, so landing it there would introduce a feature rather than fix one; it belongs in the Fraser/Skeena sync, promoting Skeena's generic version

## Phase 6: Sync Fraser and Skeena

- [ ] Sync from the template, not by hand
- [ ] **Skeena's link block differs** (`8cd061eb` vs `a655cb44`) — needs one look before syncing
- [ ] Release each

## Validation

- [x] Link check fails on Peace before the fixes, passes after
- [x] Every `sum/` and photo href resolves from a fresh clone
- [ ] `/code-check` clean on each commit
- [ ] PWF checkboxes match landed work
- [ ] `/planning-archive` on completion
