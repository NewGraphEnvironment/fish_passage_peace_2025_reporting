# Task Plan: Email Workflow for BCTS/FWCP Fish Passage Communications

## Goal
Draft and send an email to Andy Upson (BCTS) providing context on Tributary to Nation River deactivation sites before a phone call, using gmailr/blastula workflow.

## Context
- Andy is not as up to speed as Stephanie on this project
- The email thread is about FWCP Fish Passage - Kennedy Siding - trib to Parsnip River - PSCIS 199663 - CHCO 11000
- Kennedy Siding project is potentially getting lined up - this is good news to acknowledge
- Stephanie is in meetings all week
- Tone should be informal but brief

## Phases

### Phase 1: Fetch Email Thread Context
- **Status:** `complete`
- **Tasks:**
  - [x] Set up gmailr authentication
  - [x] Search for Andy Upson email thread
  - [x] Fetch full thread content (8 messages)
  - [x] Document thread in findings.md

### Phase 2: Draft Email
- **Status:** `complete`
- **Tasks:**
  - [x] Review thread tone and content
  - [x] Draft informal email with:
    - Acknowledgment of Kennedy Siding progress (15m bridge, 2026 project)
    - Nod to Stephanie being in "meeting purgatory"
    - Context on Nation River deactivation sites (enhancement work above minimum)
    - Timing discussion (riding into 2026)
  - [x] Save to R script for blastula

### Phase 3: Review and Send
- **Status:** `in_progress`
- **Tasks:**
  - [ ] Preview email in RStudio
  - [ ] Make any final tweaks
  - [ ] Send via blastula

## Key Files
- `/communications/email_andy_upson_nation_river_deactivation.R` - email script
- `/communications/findings.md` - email thread content & context
- Proposal doc: `/Users/airvine/Projects/repo/fish_passage_peace_2026_proposal/sern_fwcp_peace_proposal_2026_2027.Rmd`

## Errors Encountered
| Error | Attempt | Resolution |
|-------|---------|------------|
| gmailr non-interactive auth | 1 | User authenticated in RStudio, token cached |
| gm_body returns list | 1 | Need to handle body type properly |
