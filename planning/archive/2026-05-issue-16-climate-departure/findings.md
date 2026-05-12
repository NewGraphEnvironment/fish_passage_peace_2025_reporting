# Findings — Climate departure body section + appendix (#16)

## Issue context

Port climate-departure analysis from the `cd` R package into the Peace 2025 reporting repo. Three pieces: methods paragraph in `0300-methods.Rmd`, results paragraph with hidden rollup chunk in `0400-results.Rmd`, and full appendix `0880-appendix-climate-departure.Rmd`.

## Key finding: cd needed at render time

Unlike the floodplain appendix (where `flooded` is only needed by the build script), `cd` IS needed at render time. The appendix calls `cd::cd_compare()`, `cd::cd_summary()`, `cd::cd_plot_timeseries()`, and `cd::cd_trend()` for plotting and summary tables. The body rollup chunk does NOT need cd — only reads from cached RDS.

## Data path mapping

| Source in cd package | Destination in Peace repo |
|---------------------|--------------------------|
| `inst/extdata/example_aoi_fwcp_peace.gpkg` | `data/gis/cd_peace.gpkg` (layer: aoi) |
| `inst/extdata/context_fwcp_peace.gpkg` (7 layers) | `data/gis/cd_peace.gpkg` (layers: ecoregions, towns, lakes, rivers, streams, highways, wsgs) |
| `inst/vignette-data/peace_fwcp.rds` | `data/gis/cd_peace.rds` |
| `inst/vignette-data/peace_fwcp_departure_tmean.tif` | `data/gis/cd_peace_departure_tmean.tif` |
| `inst/extdata/peace_wsg_ecoregion_commentary.csv` | `data/gis/cd_peace_wsg_ecoregion.csv` |

## Citation keys (9 total)

`hansen_etal2012Perceptionclimate`, `karl_etal1993NewPerspective`, `mote_etal2018Dramaticdeclines`, `mote_etal2005DECLININGMOUNTAIN`, `stewart_etal2005ChangesEarlier`, `cayan_etal2001ChangesOnset`, `knowles_etal2006TrendsSnowfall`, `pepin_etal2015Elevationdependentwarming`, `kang_etal2016ImpactsRapidly`

## Lesson from #14

All sub-headings inside unnumbered appendix chapters MUST use `{-}` to suppress section numbering.
