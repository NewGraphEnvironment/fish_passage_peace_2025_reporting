# Task: Add monitoring appendices for PSCIS 125179, 125131, and 198692 (#24)

Effectiveness and baseline monitoring was conducted at three sites in 2025 — 125179 (Trib to Missinka), 125131 (Trib to Table), and 198692 (Kerry Lake). All three have appendices in past Peace reports, so the new appendices should be **short and sweet** — just the new 2025 data, with cross-refs back to the prior-year appendices for site location, background, and history. Don't regurgitate what already exists elsewhere.

**Per-site lean structure:**

- One-paragraph intro: where + what was done this year + link to prior-year appendix
- `## Monitoring Form` — filtered monitoring form data table
- `## Fish Sampling` — narrative + per-site fish summary + density plot
- `## Environmental DNA` — cross-ref to `#app-edna` + site-specific commentary
- `## Conclusion` — one paragraph (effectiveness vs baseline framing)

## Phase 1 — Data ingestion (gating; nothing else proceeds without this)

- [ ] Locate `form_monitoring_2025.gpkg` source (Mergin project `sern_peace_fwcp_2023` likely backup path)
- [ ] Copy to `data/form_monitoring_2025.gpkg`
- [ ] Tidy talk-to-text fragments in form comment fields at the gpkg level
- [ ] Set `index.Rmd` `update_form_monitoring: TRUE`, build once to populate sqlite
- [ ] Set param back to `FALSE`
- [ ] Verify `form_monitoring` loads with rows for 125179, 125131, 198692
- [ ] Verify per-site `tab_monitoring`, `tab_fish_summary`, `fish_abund` entries
- [ ] Copy photos for the 3 sites to `data/photos/<site>/`
- [ ] **Gate**: confirm what works before proceeding

## Phase 2 — Build 125179 (Trib to Missinka)

- [ ] Create `0860-appendix-125179-trib-to-missinka.Rmd` with lean structure
- [ ] Anchor `{-#trib-to-missinka-2025}`
- [ ] Test `tab_monitoring` render first, then add fish sampling, then eDNA cross-ref, then conclusion + photos
- [ ] Build, verify clean

## Phase 3 — Build 125131 (Trib to Table)

- [ ] Verify 125131 vs 125231 site-ID accuracy in body text references
- [ ] Create `0860-appendix-125131-trib-to-table.Rmd` mirroring 125179
- [ ] Anchor `{-#trib-to-table-2025}`
- [ ] Build, verify clean

## Phase 4 — Build 198692 (Kerry Lake) — baseline framing

- [ ] Create `0860-appendix-198692-trib-to-kerry-lake.Rmd` mirroring 125179
- [ ] Anchor `{-#trib-to-kerry-2025}`
- [ ] Intro frames as **baseline ahead of planned remediation**
- [ ] Conclusion: "baseline collected to inform future effectiveness monitoring"
- [ ] Build, verify clean

## Phase 5 — Body cross-refs + release

- [ ] Replace external 2024-URL links in `0400-results.Rmd` Monitoring section with internal anchors
- [ ] Optionally add anchors in exec summary 3-site sentence
- [ ] Full build, verify
- [ ] Bump DESCRIPTION 0.4.1 → 0.5.0; NEWS entry
- [ ] Commit, push, PR

## Validation

- [ ] Tests pass
- [ ] `/code-check` clean on each commit
- [ ] PWF checkboxes match landed work
- [ ] `/planning-archive` on completion
