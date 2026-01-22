# Findings: Fish Presence by Habitat Type Fix

## Key Discovery: Wrong Watershed Groups

### Current 2025 Configuration (INCORRECT)
From `scripts/02_reporting/0145-analyze-fish.R` lines 4-5:
```r
wsg <- c('LCHL', 'NECR', 'FRAN', "MORK", "UFRA")
species_of_interest <- c('BT', 'CH', 'CM', 'CO', 'CT', 'DV', 'PK', 'RB','SK', 'ST')
```

These watershed codes translate to:
- LCHL = Lower Chilcotin
- NECR = Nechako
- FRAN = Fraser
- MORK = Morkill
- UFRA = Upper Fraser

Species include many anadromous (CH=Chinook, CM=Chum, CO=Coho, PK=Pink, SK=Sockeye, ST=Steelhead) and coastal species (CT=Cutthroat, DV=Dolly Varden) that are NOT in the Parsnip watershed.

### Correct 2024 Configuration
From `data/inputs_extracted/fiss_sum_grad.csv` (2024 repo):
- Species: **BT** (Bull Trout), **GR** (Arctic Grayling), **KO** (Kokanee), **RB** (Rainbow Trout)
- Watershed: Parsnip River

## Data Comparison

### 2024 Species in fiss_sum_grad.csv
| Species | Total Observations |
|---------|-------------------|
| BT | 236 |
| GR | 230 |
| KO | 17 |
| RB | 415 |

### 2025 Species in fiss_sum_grad.csv (WRONG)
| Species | Total Observations |
|---------|-------------------|
| BT | 109 |
| CH | 186 |
| CM | 4 |
| CO | 491 |
| CT | 572 |
| DV | 940 |
| PK | 87 |
| RB | 1139 |
| SK | 45 |
| ST | 460 |

## Correct Configuration (from params)

**Watershed Group Codes:** `PARS, CARP, CRKD, NATR, PARA`
- PARS = Parsnip
- CARP = Carp Lake
- CRKD = Crooked
- NATR = Nation
- PARA = Parsnip Arm

**Species of Interest (based on 2024):** `BT, GR, KO, RB`
- BT = Bull Trout (Blue listed, COSEWIC Special Concern)
- GR = Arctic Grayling
- KO = Kokanee
- RB = Rainbow Trout

## Species Presence by Watershed (2025 fiss_species_table.csv)

| Species | Carp Lake | Crooked | Nation | Parsnip Arm | Parsnip |
|---------|-----------|---------|--------|-------------|---------|
| Bull Trout (BT) | Yes | Yes | Yes | Yes | Yes |
| Arctic Grayling (GR) | - | - | Yes | Yes | Yes |
| Kokanee (KO) | - | - | Yes | Yes | Yes |
| Rainbow Trout (RB) | Yes | Yes | Yes | Yes | Yes |

## Script Changes Required

In `scripts/02_reporting/0145-analyze-fish.R`:

**Line 4 - Change FROM:**
```r
wsg <- c('LCHL', 'NECR', 'FRAN', "MORK", "UFRA")
```

**Line 4 - Change TO:**
```r
wsg <- c('PARS', 'CARP', 'CRKD', 'NATR', 'PARA')
```

**Line 5 - Change FROM:**
```r
species_of_interest <- c('BT', 'CH', 'CM', 'CO', 'CT', 'DV', 'PK', 'RB','SK', 'ST')
```

**Line 5 - Change TO:**
```r
species_of_interest <- c('BT', 'GR', 'KO', 'RB')
```

## Build Issues Discovered

### packages.R comparison

| Feature | mybookdown-template | fish_passage_template_reporting |
|---------|--------------------|---------------------------------|
| pak update check | None (clean) | Lines 2-10 - breaks non-interactive |
| ggdark | Not included | Line 21 - causes theme errors |
| GitHub branch suffix | Has `@commit` but fewer packages | `fishbc@updated_data` breaks require() |

**Root cause:** fish_passage_template_reporting diverged from mybookdown-template with additions that break CI/command-line builds.

**Issues filed:**
- #149 - ggdark removal
- #150 - packages.R fixes (pak check, basename issue)

## File Locations

### 2025 Worktree (to fix)
- Script: `scripts/02_reporting/0145-analyze-fish.R`
- Output: `data/inputs_extracted/fiss_sum_grad.csv`
- Output: `data/inputs_extracted/fiss_sum_width.csv`
- Output: `data/inputs_extracted/fiss_sum_wshed.csv`
- Report: `0200-background.Rmd`

### 2024 Reference (correct)
- Data: `/Users/airvine/Projects/repo/fish_passage_peace_2024_reporting/data/inputs_extracted/fiss_sum_grad.csv`
- Report: `/Users/airvine/Projects/repo/fish_passage_peace_2024_reporting/0200-background.Rmd`
