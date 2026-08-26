# Findings — dead links in the results interactive map

## Two causes, one symptom

The results map's popups carry three links per site: Culvert Photos, Culvert Data, Model Data. In published Peace 2025 (`4f66690`) **49 of them are dead**, from two unrelated causes.

### Photo links use the wrong id (#61)

`scripts/02_reporting/0130-tables.R:908` prefers the reference id:

```r
photo_link = dplyr::case_when(
  is.na(my_crossing_reference) ~ paste0(... '/data/photos/', pscis_crossing_id,     '/crossing_all.JPG ...'),
  TRUE                         ~ paste0(... '/data/photos/', my_crossing_reference, '/crossing_all.JPG ...'))
```

But photo folders are renamed **to PSCIS ids** by `0110_photos.R` — `0160_add_pscis_ids.R:179` states it: *"To rename photo folders with PSCIS IDs, rerun `0110_photos.R`"*. So every row with a non-NA `my_crossing_reference` points at a folder that no longer exists.

| | Count |
|---|---|
| Distinct photo links in the map | 19 |
| 404 — built from `my_crossing_reference` | 15 |
| 200 — built from `pscis_crossing_id` | 4 |

Live-verified:

```
HTTP 404  .../main/data/photos/15200985/crossing_all.JPG   (modelled crossing id)
HTTP 200  .../main/data/photos/203597/crossing_all.JPG     (pscis id)
```

8-digit ids are modelled-crossing ids; all 28 tracked photo folders are 6-digit PSCIS ids. **Not limited to reassessments**, which is what #61 was unsure about.

### Culvert and model pages never generated (#231)

34 links to `sum/cv/<id>.html` and `sum/bcfp/<id>.html`; `docs/sum/` does not exist. Built by `scripts/02_reporting/0190-build-html-map-tables.R`, which is in **no repo's build chain**. Its header states the design: *"Let's just make the HTML tables when we need to"*.

It also opens by deleting its output directory (`fs::file_delete("docs/sum/bcfp")`), so an interrupted run leaves nothing rather than a stale copy.

## Spread across repos

Both defects are in all four repos. The link-building block is **byte-identical** in template, Peace and Fraser; Skeena's differs.

| Repo | `0130-tables.R` link block | `docs/sum` committed | `0190` in build chain |
|---|---|---|---|
| template | `a655cb44` | no | no |
| peace_2025 | `a655cb44` | no | no |
| fraser_2025 | `a655cb44` | no | no |
| skeena_2025 | `8cd061eb` | no | no |

That identity is why the fix should be developed here and transplanted, rather than hand-applied four times — hand-application is how this file reached four different md5s in the first place.

## Why not {targets}

Recorded because it will be asked again. A DAG-based pipeline would not have caught any of the three dead-link defects. `{targets}` answers *"what needs recomputing"*. Every failure here was *"the artifact was never produced, or was produced and never committed"* — a DAG that rebuilds `docs/sum/` still leaves it untracked, and it cannot know that a photo folder naming scheme changed upstream in `0110_photos.R`.

The `update_*` switch family already does cache-with-invalidation for the expensive inputs (`update_bcfishpass` is exactly that) and is working. The gap is verification of output, which is far cheaper to close. Revisit orchestration frameworks when build *time* is the pain; right now it is correctness.

## Related history

Same shape as the eDNA map (#230), where the map HTML had never been committed and the appendix link returned 404 on the published site — fixed in `fish_passage_skeena_2025_reporting@32a654c`. Three instances of one pattern: an artifact the published site links to, produced by a manual script, verified by nothing.

## The DOM is not enough (Phase 1)

First version of the check parsed `href`/`src` attributes with `xml2` and reported the report as almost clean — **2 broken links out of 51**. Leaflet popups are serialised as JSON inside a `<script>` tag, so their links are never parsed as attributes, and those popups are exactly where the dead photo and `sum/` links live.

The raw pass also has to cope with how the popup markup is written. `paste0('<a href =', 'sum/cv/', id, '.html ', ...)` emits `href =sum/cv/203597.html ` — a space after `=`, and no quotes — which most href regexes miss.

One PCRE trap: lookbehind must be fixed width, so `(?<=href *= *)` fails to compile. Match the attribute name and strip it afterwards.

## Third finding, unrelated to the two known causes

The check also flagged `attach-pdf-phase1-dat.html`, linked from `docs/ai-disclosure.html` and `docs/changelog.html`. That anchor is only emitted when `gitbook_on` is FALSE (`0400-results.Rmd:256`), so those two pages are **stale artifacts left in `docs/` from an earlier PDF build** — bookdown does not clean the output directory. Worth watching whether the Phase 4 rebuild clears them.
