# Findings — Monitoring appendices for PSCIS 125179, 125131, 198692 (#24)

## Issue context

See [#24](https://github.com/NewGraphEnvironment/fish_passage_peace_2025_reporting/issues/24).

## Plan-mode exploration

### 2024 Peace appendix precedents
- `fish_passage_peace_2024_reporting/0800-appendix-125179-trib-to-missinka.Rmd` (~290 lines) — full structure: site location + background + monitoring + fish sampling + reference site (125180) + conclusion + photos. **Too long for our lean structure** — we keep just monitoring form, fish, eDNA, conclusion + intro paragraph; everything else lives in 2024 appendix (linked).
- `fish_passage_peace_2024_reporting/0800-appendix-198692-trib-to-kerry-lake.Rmd` — Kerry Lake was a 2024 habitat confirmation; 2025 reframes as baseline-pre-remediation.
- No prior per-site appendix for 125131. Use 125179 lean structure as template.

### Data plumbing
- `form_monitoring` source: `data/form_monitoring_<year>.gpkg` (path defined at `scripts/02_reporting/0130-tables.R:24-29`).
- Loaded into sqlite when `params$update_form_monitoring: TRUE` (line 162-184).
- Derived tables in same file: `tab_fish_summary` (line 613), `fish_abund` (line 650), `tab_monitoring` (line 964).
- `data/form_monitoring_2025.gpkg` **does not exist yet** — must be sourced from Mergin sync.

### Photo plumbing
- `data/photos/<site>/<photo_str>.JPG` pattern; `fpr::fpr_photo_pull_by_str()` resolves files by substring match against the photo filename.
- 2025 photos exist for 199663, 203597-203611, 6559. **Not present** for 125179, 125131, 198692.

### Anchor strategy
- 2024 anchors: `#trib-to-missinka`, `#trib-to-kerry` (no year suffix).
- 2025 anchors must be unique within this build; use `*-2025` suffix to disambiguate.
- Body Results currently links to external 2024 URLs (e.g. `https://www.newgraphenvironment.com/fish_passage_peace_2024_reporting/trib-to-missinka.html`). Switch to internal anchors in Phase 5.

### User feedback on structure
- "These are short and sweet with the form, the fish, the links to the old memos the eDNA and a general site's looking good after work completed or for Kerry it's baseline data collected to inform future effectiveness monitoring."
- "We may need to wire in some of the plumbing to get the monitoring form information and may need to tidy up the text in the forms as some is talk to text."
- "Not sure the watershed metadata will be there. We should build one little piece at a time and test as you go."

### Conventions discovered
- Per-site appendices use `{.unnumbered}` on `##` headers and `{-#anchor}` on `#` (top-level) — see `0840-appendix-199663-trib-to-parsnip.Rmd` as the modern Peace 2025 reference for table wrapping and chunk patterns.
- Photo pairs: gitbook gets two separate `photo-NNNNN-0X` chunks (full width); PDF gets one `photo-NNNNN-d0X` chunk with `out.width = c("49.5%","1%","49.5%")` side-by-side using `fig/pixel.png` as spacer.
