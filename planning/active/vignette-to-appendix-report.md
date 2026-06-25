# Vignette-to-appendix transfer — Habitat & Connectivity Classification (#34)

**Source vignette:** `~/Projects/repo/link/vignettes/pars-habitat-connectivity.Rmd` (link @ v0.43.0 / 29e3e92)
**Destination repo:** `~/Projects/repo/fish_passage_peace_2025_reporting`
**Topic slug:** `habitat-connectivity`  ·  **Short code:** `link`
**Proposed appendix file:** `0760-appendix-habitat-connectivity.Rmd` (slot 0760, user-directed — 07X0 "Appendix-" methodology group, NOT the skill's 08X0 default)
**Mode:** report-only (no files written to the report body; drafts in scratchpad)

## Pre-flight findings

| Check | Status | Detail |
|---|---|---|
| Render-time vs build-time dependency | **WARN** | `link` = build-script-only (no `link::`/`lnk_*` in any render chunk after the `eval=FALSE` model-run chunk is stripped) → **remove `library(link)`**. Ancillary **render-time** deps: `gq` (`gq::gq_reg_main`, `gq::gq_tmap_classes` in `link-symbology`) and `sf`. |
| `gq` present in destination | **WARN** | `gq` is NOT in `scripts/packages.R` and NOT currently used anywhere in Peace. Must be installed (`pak::pak("NewGraphEnvironment/gq")`) and added to `packages.R` or the render errors. `sf` already loaded. |
| AOI cardinality | **WARN (intentional)** | Source is scalar `aoi = "PARS"`; Peace is multi-WSG. This appendix is a deliberate single-WSG (Parsnip) showcase, so scalar is correct — flagged only so it's a conscious choice. |
| terra mean() usage | PASS | No terra in vignette. |
| GNS feature_type literal | PASS | None. |
| available.packages() | PASS | None in vignette. |
| **AOI-neutral filename collision** | **FAIL → resolved by rename** | Source `pars.gpkg` (11.55 MB, sha f964ed7…) would overwrite the **existing** `data/gis/pars.gpkg` (12.99 MB, the floodplain transfer's data — DIFFERENT content). Mandatory rename: `pars.gpkg`→`habitat-connectivity.gpkg`, `pars_parity.rds`→`habitat-connectivity_parity.rds`. No collision under those names. |
| Filename-slot drift | INFO | Issue #34 said "08X0"; user directed 0760. Draft uses 0760. |
| rbbt online (destination) | INFO | Confirm Peace `update_bib` state before render; vignette adds no `@citekey` refs, so low risk. |
| Citation keys | INFO | Vignette prose cites no `@keys` (mentions COSEWIC / blue-list narratively). If you want those cited, that's net-new bib work, not part of the transfer. |
| Narrative-freshness | n/a | Source is `link` (not `cd`); no banner. Source is PARS-specific so no prior-region leakage risk. |
| **Hardcoded data values in prose** | **WARN** | Run-specific numbers embedded in captions/prose: "19,233 vs 31,932 classified segments" + "1,764" (`link-map-gr` caption, `link-map-detail` caption + prose), "99.66%" reference median (`link-parity-pct`), "~5,600 km²" (intro). Re-verify against the committed cache or convert to inline R. Tracked as review F1–F3. |

## Mechanical transformations applied (in the scratchpad draft)

- **YAML strip** → `output: html_document` + `editor_options: chunk_output_type: console` (matches sibling `0730`/`0720`).
- **Heading insert** → `# Appendix - Bull Trout and Arctic Grayling: Habitat and Connectivity Classification for the Parsnip River Watershed Group {-#app-habitat-connectivity}` (unbolded, Fraser-canonical). Long — shortening is a flagged judgment call.
- **Sub-heading `{-}`** appended to all 5 `## ` lines (Modelling parameters / Cached inputs / Reproducing bcfishpass (parity) / Arctic grayling — a link extension / Maps — detail comparison).
- **Chunk-label prefix `link-`** on all chunks: setup, params, load, parity-table, parity-pct, symbology, map-bt, map-gr, map-detail.
- **Knitr opts strip** — removed `knitr::opts_chunk$set(...)` from setup (parent `index.Rmd` controls globally).
- **`library(link)` removed** (build-script-only); `library(sf)` consolidated into `link-setup` to match the floodplain sibling.
- **Data-path rewrite** — both `system.file("vignette-data/…", package="link", mustWork=TRUE)` → `data/gis/habitat-connectivity.gpkg` / `…_parity.rds` (AOI-neutral rename applied; `mustWork` dropped).
- **`eval=FALSE` chunk stripped** — the `model-run` chunk (live pipeline demo) removed, along with its "shown here for reference, not executed at build time" reference paragraph.
- **Cached-inputs download URLs stripped** — the GitHub `raw` download bullets replaced with a plain description of the cached layers.
- **Chunk-option strip** — removed `echo=FALSE` from params/parity-table/parity-pct/map-* and `dpi`/`collapse`/`comment` from setup; kept `fig.cap`, `fig.width`, `fig.height`, `results="asis"`, and `include=FALSE` on load/symbology.
- Prose left largely intact for your polish (vignette register flagged as review F4) — the skill scaffolds, it does not rewrite narrative.

## Drafts written to scratchpad

`<scratchpad>/vignette-to-appendix/`
- `habitat-connectivity-appendix-draft.Rmd` — the transformed appendix
- `0300-methods-snippet.md` — cross-ref to append to the existing fresh+link methods paragraph
- `0400-results-snippet.md` — cross-ref + optional hidden rollup chunk for inline numbers
- `manifest-entry.txt` — sha256 + link@version + date for both data files
- `scripts-gis-habitat-connectivity.R` — build script (copies + renames cached data; configuration-iteration shape)

Review scaffold + this report live in `planning/active/` (review-habitat-connectivity.md, this file).

## Judgment calls flagged for you

1. **Body wiring is cross-ref, not new sections.** Peace already narrates the `fresh`+`link`
   framework in Methods *and* Results. The snippets default to appending a cross-ref sentence
   to those existing paragraphs (Option A), not adding `## ` sections. Confirm that's the intent.
2. **Multi-entity (BT + GR)** is handled inside the appendix itself (parity map + extension map +
   detail comparison). No per-entity results subsections needed — the body just points to the appendix.
3. **Title length** — the full source title is long; shorten to e.g. "Habitat and Connectivity
   Classification" or keep the descriptive form?
4. **Hardcoded caption numbers (F1–F3)** — re-verify vs the committed cache or soften. Caption text
   can't easily be inline-R.
5. **`gq` dependency** — install + add to `packages.R` before render.
6. **gpkg commit** — DECIDED: commit `habitat-connectivity.gpkg` (11.55 MB) per your call.

## Next steps (Phase 2 onward — `--apply` or by hand)

1. Review the scratchpad draft appendix.
2. Run/adapt `scripts-gis-habitat-connectivity.R` to copy+rename the cached data into
   `data/gis/habitat-connectivity.{gpkg,rds}` (link must be installed). Commit the gpkg.
3. Add `gq` to `scripts/packages.R`; install it.
4. Move the draft to `0760-appendix-habitat-connectivity.Rmd`.
5. Wire the two cross-refs into `0300-methods.Rmd` + `0400-results.Rmd` (Option A snippets).
6. Build gitbook (`scripts/run_gitbook.R`) — verify appendix renders, 3 maps + parity table appear, cross-refs resolve.
7. Build pagedown (`scripts/run_pagedown.R`) — verify maps render static, legend not clipped.
8. Spawn fresh-context gating review using `planning/active/review-habitat-connectivity.md`.
9. Address review findings; NEWS + version bump; PR (Relates to #34; link#215 source).
