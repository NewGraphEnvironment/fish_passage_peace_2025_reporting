# fish_passage_peace_2025_reporting 0.1.2 (2026-05-08)

* Consume `fp_sites_tracking.parquet` snapshot from upstream fptr (v0.0.2) instead of querying postgres live; new `scripts/fp_inputs_snapshot.R` mirrors the existing eDNA pattern; Peace now builds from a fresh clone with no DB access at runtime ([Issue #10](https://github.com/NewGraphEnvironment/fish_passage_peace_2025_reporting/issues/10))

# fish_passage_peace_2025_reporting 0.1.1 (2026-05-05)

* Repair 23 drifted citation keys in prose; pin clean keys on 2 `&`-blocked Zotero entries; flip `update_bib: TRUE` so future drift is caught at build time ([Issue #7](https://github.com/NewGraphEnvironment/fish_passage_peace_2025_reporting/issues/7))

# fish_passage_peace_2025_reporting 0.1.0 (2026-05-05)

* Integrate eDNA results into Peace 2025 report (#6, PR #8)
