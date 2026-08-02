# Findings — #34 link Parsnip vignette → appendix

## Source vignette (link main @ 29e3e92 / v0.43.0)

`vignettes/pars-habitat-connectivity.Rmd` — "Bull trout and Arctic grayling: habitat
and connectivity classification for the Parsnip River Watershed Group". 483 lines.
Produced under link#215 (planning archived in link at
`planning/archive/2026-06-issue-215-vignette-pars-mapping-code/`).

**What it does:** runs `link`'s per-segment `mapping_code` classification (access /
spawning / rearing + downstream barrier type) over the full FWA stream network of the
Parsnip River Watershed Group (`PARS`, ~5,600 km²). Two parts:
1. **Parity** — `link`'s bcfishpass configuration reproduces bcfishpass's per-segment
   classification for bull trout (`BT`), byte-checkable against the upstream reference.
2. **Extension** — same method applied to Arctic grayling (`GR`), which bcfishpass does
   not yet model in the Peace.

**Structure (headings):** Modelling parameters · Cached inputs · Reproducing bcfishpass
(parity) · Arctic grayling — a link extension · Maps — detail comparison.

**Figures (3, all static — carry to PDF):**
- `map-bt` — BT per-segment mapping_code across the WSG (bcfishpass symbology registry)
- `map-gr` — GR per-segment mapping_code across the WSG (link default config)
- `map-detail` — SE-corner detail, BT vs GR side-by-side, same extent
**Tables:** `parity-table` + `parity-pct` (BT parity vs bcfishpass).

**Reported counts (from fig captions):** BT 31,932 classified segments; GR 19,233;
1,764 GR segments carry no BT classification at all (net-new output vs bcfishpass).

## Cached data inputs

Vignette reads via `system.file("vignette-data/...", package = "link")`:
- `inst/vignette-data/pars.gpkg` — 11.5 MB (stream network + context layers)
- `inst/vignette-data/pars_parity.rds` — 272 B (parity comparison object)

Skill rewrites these to `data/gis/<file>`. **Open Q:** 11.5 MB gpkg — gitignore vs commit
(data-snapshot challenge; CLAUDE.md flags sqlite/binary bloat). Decide in Phase 1.

## Body cross-reference insertion points (Peace)

- **Methods** `0300-methods.Rmd` — paragraph "We are building a parameterizable
  habitat-suitability and connectivity framework using `fresh` and `link`..."
  (*Statistical Support for Habitat Modelling*). Describes the Arctic grayling intrinsic-
  habitat model "in development at the time of this report".
- **Results** `0400-results.Rmd` — paragraph "Alongside the weekly automated updates, we
  use our open-source R packages `fresh` and `link`..." under *## Statistical Habitat
  Modelling Outputs*.

Both already name the work; they just need a pointer to the new appendix.

## Appendix placement

Peace's "Appendix -" methodology group is `07X0` (0700 site-assessment, 0710 fish-species,
0720 climate-departure, 0730 floodplain, 0740 uav, 0750 collaborative-gis). The `08X0`
range is Phase-1/eDNA/Phase-2-site/monitoring. This habitat-connectivity appendix is a
methodology/framework showcase → belongs in the `07X0` group (likely `0760`), NOT `08X0`.
The skill's default "highest `08X0` + 5" heuristic will mis-slot it — override the slug/slot.
Order by first body reference (consistent with the appendix-ordering convention adopted
in the 0.9.0 reorg).

## Skill notes

`/vignette-to-appendix` (soul#50): report-only by default; `--apply` writes drafts (no
render/commit/push). Source-package short code = `link`. Needs dest `_bookdown.yml` (present).
