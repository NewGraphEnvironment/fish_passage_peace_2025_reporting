# Restoring Fish Passage in the Peace Region — 2025

> Reproducible, web-first fish-passage restoration-planning report for the Peace Region, prepared on behalf of the [Fish & Wildlife Compensation Program (FWCP)](https://fwcp.ca/) and its program partners (BC Hydro, the Province of BC, Fisheries and Oceans Canada, First Nations, and public stakeholders).

**Read the report:** <https://www.newgraphenvironment.com/fish_passage_peace_2025_reporting>
&middot; **Source:** [`NewGraphEnvironment/fish_passage_peace_2025_reporting`](https://github.com/NewGraphEnvironment/fish_passage_peace_2025_reporting)
&middot; **Version history:** [`NEWS.md`](NEWS.md)

## What this is

The 2025 iteration of the Peace Region fish-passage restoration-planning report. Builds on the 2024 framing with new field data, refined prioritization, a climate-departure appendix grounding the planning horizon in observed climate change, and a standalone executive-summary PDF for partners who need the headline findings without the full report. Source data and methods are open — anyone can rebuild the report from `scripts/run.R`.

## Sections

- **Executive Summary** ([`0050-executive-summary.Rmd`](0050-executive-summary.Rmd)) + standalone PDF (`_executive_summary_pdf.Rmd`)
- **Introduction** ([`0100-intro.Rmd`](0100-intro.Rmd))
- **Background** ([`0200-background.Rmd`](0200-background.Rmd))
- **Methods** ([`0300-methods.Rmd`](0300-methods.Rmd))
- **Results** ([`0400-results.Rmd`](0400-results.Rmd))
- **Recommendations** ([`0500-recommendations.Rmd`](0500-recommendations.Rmd))
- **Fish species appendix** ([`0700-appendix-fish-species.Rmd`](0700-appendix-fish-species.Rmd))
- **Site-assessment-data appendix** ([`0810-appendix-site-assessment-data.Rmd`](0810-appendix-site-assessment-data.Rmd))
- **Climate-departure appendix** ([`0820-appendix-climate-departure.Rmd`](0820-appendix-climate-departure.Rmd))

## Build

```r
source("scripts/run.R")
```

`scripts/run.R` sources `scripts/staticimports.R` (which inlines helper functions via the [staticimports](https://github.com/wch/staticimports) package) and then runs `bookdown::render_book()`. Bypassing `run.R` gives "undefined function" errors at render time.

## Open-source packages used

| Package | Role |
|---|---|
| [`fresh`](https://github.com/NewGraphEnvironment/fresh) | FWA stream-network primitives + habitat classification driving accessible / spawning / rearing layers. |
| [`link`](https://github.com/NewGraphEnvironment/link) | Cross-system crossing matching + barrier-override resolution from observation evidence. |
| [`ngr`](https://github.com/NewGraphEnvironment/ngr) | Reporting utilities — table formatting, S3 helpers, STAC, GitHub-issue scraping. |
| [`fpr`](https://github.com/NewGraphEnvironment/fpr) | Fish-passage-specific reporting functions (PSCIS tables, crossing details). |
| [`gq`](https://github.com/NewGraphEnvironment/gq) | Cartographic style registry across the report's maps. |
| [`cd`](https://github.com/NewGraphEnvironment/cd) | Climate-departure analysis feeding the climate-departure appendix. |
| [`cred`](https://github.com/NewGraphEnvironment/cred) | Post-draft citation verification across references. |

External: [`bcfishpass`](https://github.com/smnorris/bcfishpass), [`fwapg`](https://github.com/smnorris/fwapg).

## License

MIT (see [`LICENSE`](LICENSE)). Indigenous traditional knowledge shared with this work remains the cultural and intellectual property of the contributing Nations; sharing or republishing those contributions requires explicit consent.
