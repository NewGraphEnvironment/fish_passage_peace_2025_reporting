## Outcome

Ported the `link` package vignette `pars-habitat-connectivity.Rmd` into the Peace 2025
report as appendix `0760-appendix-habitat-connectivity.Rmd` ("Parsnip River Habitat and
Connectivity Modelling"), and wired high-level cross-references from the Methods and
Results sections that describe the `fresh` + `link` framework. Cached vignette data was
copied to `data/gis/habitat-connectivity.{gpkg,rds}` — renamed from the source `pars.gpkg`
because that filename already held an unrelated floodplain layer in this repo. `gq` was
added to `scripts/packages.R` as a render-time dependency.

The substantive work beyond the mechanical transfer was a full rewrite from vignette
register into tech-report "we" voice: cutting cached-input and symbology mechanics,
function and config names, and stale hardcoded counts. Two render fixes were needed — a
local `params` -> `param_tab` rename to avoid a bookdown locked-binding collision, and a
`gq` reinstall from local HEAD after pak served a stale build missing `gq_tmap_classes()`
widths.

Gitbook output verified: appendix renders with three maps plus the parity table, and all
cross-references resolve. One defect deferred rather than fixed — the three base-R/sf maps
render blank in the pagedown PDF (gitbook is fine) because the wide-margin legend consumes
the plot region at PDF figure size. Filed upstream as
NewGraphEnvironment/mybookdown-template#91.

Learnings were captured back into the `/vignette-to-appendix` skill and
`soul/conventions/vignette_to_appendix.md` — a Tone & register section plus pre-flight
checks and transform steps.

Closed by: commits 522b8d7 (appendix + cross-refs) and ece0218 (parity table simplification),
both on main. Issue #34 remains open pending the deferred PDF map defect; it did not
auto-close because the commit referenced `(#34)` rather than a closing keyword.
