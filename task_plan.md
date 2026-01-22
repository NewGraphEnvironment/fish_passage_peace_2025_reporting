# Task Plan: Fix Fish Presence by Habitat Type Section

## Goal
Fix the "Fish presence by Habitat Type" section in the 2025 Peace report to show the correct species for the Parsnip River watershed (matching 2024 configuration) instead of the current incorrect species list.

## Problem Summary
The 2025 report currently shows species from **different watershed groups** (LCHL, NECR, FRAN, MORK, UFRA - Lower Chilcotin, Nechako, Fraser, Morkill, Upper Fraser) with species like CH, CM, CO, CT, DV, PK, SK, ST - many of which are anadromous/coastal species not present in the Parsnip.

The 2024 report correctly shows **Parsnip River watershed** species: BT (Bull Trout), GR (Arctic Grayling), KO (Kokanee), RB (Rainbow Trout).

## Root Cause
In `scripts/02_reporting/0145-analyze-fish.R`:
- **Line 4**: `wsg <- c('LCHL', 'NECR', 'FRAN', "MORK", "UFRA")` - Wrong watershed group codes
- **Line 5**: `species_of_interest <- c('BT', 'CH', 'CM', 'CO', 'CT', 'DV', 'PK', 'RB','SK', 'ST')` - Wrong species list

Should be changed to match 2024 report Parsnip configuration.

## Phases

### Phase 1: Research - Identify Correct Parameters
**Status:** `complete`

- [x] Determine correct watershed group code(s): **PARS, CARP, CRKD, NATR, PARA**
- [x] Identify correct species of interest: **BT, GR, KO, RB**
- [x] Cross-reference with `fiss_species_table.csv` - confirmed species presence across watersheds

### Phase 2: Update Data Extraction Script
**Status:** `complete`

- [x] Modify `scripts/02_reporting/0145-analyze-fish.R`:
  - Updated `wsg` to `c('PARS', 'CARP', 'CRKD', 'NATR', 'PARA')`
  - Updated `species_of_interest` to `c('BT', 'GR', 'KO', 'RB')`
  - Fixed ggdark → theme_bw (refs #149)
  - Fixed rws_drop_table to check existence first
- [x] SQL query structure valid - ran successfully

### Phase 3: Regenerate Data Files
**Status:** `complete`

- [x] Run the updated `0145-analyze-fish.R` script
- [x] Verified new CSV files generated in `data/inputs_extracted/`:
  - `fiss_sum.csv` - 177KB, correct watersheds
  - `fiss_sum_grad.csv` - shows BT, GR, KO, RB (correct!)
  - `fiss_sum_width.csv` - updated
  - `fiss_sum_wshed.csv` - updated

### Phase 4: Update Background Rmd (if needed)
**Status:** `complete`

- [x] Reviewed `0200-background.Rmd` - captions already reference "Parsnip River watershed group"
- [x] No changes needed - data files drive the content

### Phase 5: Build and Verify
**Status:** `complete`

- [x] Fixed packages.R issues (pak check, ggdark, basename) - refs #150
- [x] Added missing packages: english, pdftools
- [x] Full gitbook build successful (227/227 chunks)
- [x] Verified `docs/background.html` shows BT, GR, KO, RB (62 occurrences)

## Files to Modify

| File | Action |
|------|--------|
| `scripts/02_reporting/0145-analyze-fish.R` | Update `wsg` and `species_of_interest` |
| `data/inputs_extracted/fiss_sum*.csv` | Regenerate with correct data |
| `0200-background.Rmd` | Possibly update captions |

## Reference Files (2024 repo)
- `/Users/airvine/Projects/repo/fish_passage_peace_2024_reporting/0200-background.Rmd`
- `/Users/airvine/Projects/repo/fish_passage_peace_2024_reporting/data/inputs_extracted/fiss_sum_grad.csv`

## Errors Encountered
| Error | Attempt | Resolution |
|-------|---------|------------|
| (none yet) | | |

## Notes
- The 2024 repo does NOT have an equivalent `0145-analyze-fish.R` script visible in the same location
- The 2024 data shows Parsnip-specific species correctly
- Need to find the watershed group code for Parsnip River in BC FWA data
