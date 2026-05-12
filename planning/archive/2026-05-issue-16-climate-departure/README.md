## Outcome

Climate departure appendix (`0865-appendix-climate-departure.Rmd`) ported from `cd` package v0.3.0 with ~16 figures and 5 tables covering temperature trends, precipitation, snowpack timing, spatial departure patterns, per-ecoregion variation, and watershed-group ecoregion mapping. Added `scripts/cd_inputs_snapshot.R` to seed `data/gis/cd_peace*` cached data. Methods and results paragraphs added as a standalone `## Climate Departure` section in the main body (before Planning), with a reader-friendly intro and four bold findings using inline R values from the cached RDS. Key difference from the floodplain pattern: `cd` is needed at render time for plotting helpers (`cd_compare`, `cd_summary`, `cd_plot_timeseries`, `cd_trend`), while the body rollup chunk reads only from cached data.

Closed by: PR #17 (squash merge 4eb3d0c), tagged v0.3.0.
