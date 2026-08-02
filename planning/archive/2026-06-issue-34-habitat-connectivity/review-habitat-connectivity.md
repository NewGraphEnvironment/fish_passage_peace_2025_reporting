# Review — Habitat & Connectivity Classification Appendix + Body Sections (#34)

Reviewer: independent agent (fresh context, no implementation bias)
Reviewed: <commit sha when filled>
Date: <iso date>

Source: `link` `vignettes/pars-habitat-connectivity.Rmd` @ v0.43.0
Appendix: `0760-appendix-habitat-connectivity.Rmd` (anchor `#app-habitat-connectivity`)

## Findings

### Numerical accuracy

Seed findings from the transfer (verify each against the cached data after render):

- **F1 — hardcoded counts in figure captions.** `link-map-gr` caption hardcodes
  "19,233 vs 31,932 classified segments" and "1,764 ... no bull-trout classification";
  `link-map-detail` caption + prose repeat "1,764". These are run-specific. Confirm
  they match the current `data/gis/habitat-connectivity.gpkg` streams layer, or convert
  to inline R computed from the gpkg. Caption-embedded values can't be inline-R easily —
  at minimum re-verify against the committed cache.
- **F2 — hardcoded reference median "99.66%"** in `link-parity-pct`. This is a
  study-area median quoted as a constant. Confirm it still holds for the committed
  parity rds, or attribute/soften ("≈99.7% across the Peace study area").
- **F3 — "~5,600 km²" WSG area** in the intro prose. Verify against `aoi` layer.

### Pattern accuracy

(Spatial-gradient / network descriptions match the data; BT vs GR network-size
comparison directionally correct; the "1,764 GR-only segments" claim reproducible.)

### Significance handling

(Parity framing: is "reproduces X%" stated with the right caveats about where the
disagreements concentrate — intermittent reaches downstream of dams? No over-claiming.)

### Tone and completeness

- **F4 — vignette register leakage.** Draft still says "This appendix does two
  things..."/"shown here for reference" register and uses `lnk_compare_mapping_code()`
  function-name name-drops in prose. Decide ops-staff voice vs package-tutorial voice.
- Confirm the long title is acceptable, or shorten.

### Stand-alone framing

(No prior-region leakage — source is PARS-specific so low risk. `grep` the rendered
appendix HTML for stray "vignette".)

### Cross-references and structure

- **F5 — body cross-refs present?** Verify the `[Appendix - ...](#app-habitat-connectivity)`
  link landed in BOTH `0300-methods.Rmd` and `0400-results.Rmd` (existing fresh+link paras).
- Verify `\@ref(fig:link-map-bt|link-map-gr|link-map-detail)` resolve.
- Verify `0760` slot orders correctly in the auto-ordered `_bookdown.yml` (between
  `0750-collaborative-gis` and `0835-phase1`).

### Other

- **F6 — render-time deps.** `gq` must be installed AND added to `scripts/packages.R`
  (used via `gq::gq_reg_main()` / `gq::gq_tmap_classes()` in `link-symbology`). `sf`
  already loaded. `link` is NOT needed at render (build-script-only). Confirm the build
  doesn't error on a missing `gq`.
- **F7 — PDF path (RESOLVED, no bug).** The three maps render correctly in both gitbook
  and the pagedown PDF. An earlier "blank in PDF" call was a false positive from inspecting
  the PDF via `pdftools::pdf_convert` (poppler), which can't rasterize the embedded map
  JPEGs because they carry a malformed ICC colour profile (`read ICCBased color space
  profile error`); Preview/Acrobat render them fine. `pdfimages -list` confirms all three
  figures are embedded (840x600 JPEGs). mybookdown-template#91 closed as mis-diagnosed.

## Resolutions (implementation pass, <date>)

(Each finding gets a resolution paragraph with commit sha + file:line.)

## Reviewer re-check (<date>)

(Verify each resolution against diff + cached data + rendered HTML.)
