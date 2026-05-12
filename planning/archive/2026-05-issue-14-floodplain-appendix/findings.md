# Findings — Add floodplain delineation appendix — Parsnip pilot (#14)

## Issue context

Add a floodplain delineation appendix plus short methods + results sections in the main body that reference it. Pilot is the Parsnip River Watershed Group; the build script is generic so future reporting years can extend to other FWCP Peace watersheds.

The appendix introduces floodplains as a second axis to fish-passage assessment (lateral connectivity, off-channel rearing, wetland refugia) and presents the modelled floodplain footprint plus a summary table of off-channel habitat units within it.

### Source material

Content is prepped in [`NewGraphEnvironment/flooded`](https://github.com/NewGraphEnvironment/flooded) at `hold/9999-appendix-floodplain.Rmd` (gitignored). Cached data and the build script:

- `flooded/data-raw/wsg_vignette_data.R` — data build script (289 lines)
- `flooded/inst/vignette-data/pars.gpkg` — multi-layer vectors (9 layers, ~13 MB)
- `flooded/inst/vignette-data/pars_dem.tif` — MRDEM-30 clip (~6.5 MB)
- `flooded/inst/vignette-data/pars_valleys.tif` — `fl_valley_confine()` binary output (~112 KB)
- `flooded/inst/vignette-data/pars_meta.rds` — bcfishpass version stamp

## Exploration findings

### Appendix heading convention
Existing appendices use: `# **Appendix - Title** {-#app-slug}` (e.g., `app-edna`, `app-uav`, `app-gis`). The floodplain appendix should use `{-#app-floodplain}`.

### Chapter ordering
`_bookdown.yml` has NO `rmd_files` list — alphabetical ordering. `0870` slots between UAV (0860) and collaborative GIS (0890).

### Data loading order
Since 0400-results.Rmd renders before 0870-appendix-floodplain.Rmd, inline R variables from the appendix's `flood-rollup` chunk aren't available in the results chapter. Solution: duplicate the data-loading + rollup as a quiet `include = FALSE` chunk in 0400.

### `terra` not in packages.R
Must be loaded explicitly in the appendix setup chunk.

### `library(flooded)` not needed at render time
The appendix uses only `terra` and `sf` for rendering. `flooded` functions are only referenced in prose, not called.

### References
`@nagel_etal2014LandscapeScale` and `@hall_etal2007Predictingriver` are NOT in `references.bib`. Need to verify they exist in Zotero before build.

## Post-merge feedback

### Appendix sub-section numbering
All `##` sub-headings inside appendices MUST use `{-}` to suppress section numbering. Without it, bookdown assigns chapter numbers (e.g., `5.1 Methods`, `5.2 Results`) which is wrong for unnumbered appendix chapters. Pattern: `## Methods {-}`, `## Results {-}`. Apply to all future appendices.

### Body results section visibility
The `### Floodplain Delineation` results paragraph under `## Planning` in 0400 rendered correctly (section 4.2.2) but was hard to find nested three levels deep. Consider whether body summary paragraphs should be more prominent for future appendices.
