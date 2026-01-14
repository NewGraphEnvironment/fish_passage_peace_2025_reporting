# Findings: Email Communications

## Tone Guide

Guidelines for email tone. Use these categories when requesting email drafts.

### Casual (default)
Professional but warm. Appropriate for established working relationships.
- Direct and concise
- Friendly but not overly familiar
- No slang ("stoked", "awesome")
- No commentary on others' situations (e.g., someone being stuck in meetings)
- Express appreciation simply: "Great to hear..." / "It's great that..."

**Example phrases:**
- "It's great that one's moving."
- "We're keen on partnering on..."
- "2026 dollars probably makes sense."

### Very Casual
For close working relationships with established rapport (e.g., frequent collaborators).
- More colloquial language ok
- Light humor appropriate
- Can reference shared context/inside jokes
- Slang acceptable: "stoked", "solid"

**Example phrases:**
- "Stoked that one's moving."
- "Appreciate Stephanie pointing me your way while she's in meeting purgatory all week."
- "Sounds like riding into 2026 makes sense."

### Formal
For new contacts, senior officials, formal requests.
- Full sentences, proper structure
- No contractions
- Clear and respectful
- State purpose early

---

## Thread-Specific Context: BCTS/FWCP Fish Passage

## Email Thread Details

**Subject:** FWCP Fish Passage - Kennedy Siding - trib to Parsnip River - PSCIS 199663 - CHCO 11000

**Participants:**
- Al Irvine <al@newgraphenvironment.com>
- Andrew Upson <Andrew.Upson@gov.bc.ca> (BCTS)
- Stephanie Sundquist <Stephanie.Sundquist@gov.bc.ca>

**Thread ID:** 199d09983e25ad2c

### Message 1 (Oct 10, 2025) - Al
Initial outreach about Nation River trib deactivation and CHCO 11000 culvert:
- Thanks for chat about Nation River trib deactivation
- Leverage work this fall towards riparian rehab next spring/summer through FWCP
- CHCO 11000 culvert - did habitat confirmation, decent stream, should be fish bearing, eDNA sample taken
- Large outlet drop - undersized culvert
- PSCIS link: http://a100.gov.bc.ca/pub/pscismap/imageViewer.do?assessmentId=201049
- Proposing FWCP fund 50% of replacement (~$300k total)
- FWCP wants written agreement before releasing engineering dollars

### Message 2 (Nov 3, 2025) - Al
"Absolutely insane to think that there is a snowballs chance in Mexico that BCTS might partner with FWCP to replace this crossing in 2026/27 fiscal year."
- Dolling up proposal, including dollars (50% of ~300k)
- "We can not spend it but if we don't allocate its not a possibility"

### Message 3 (Nov 3, 2025) - Stephanie
"You miss 100% of the chances you don't take!"
- Heading to Mackenzie, Andrew home sick
- Suggested touch base Wednesday

### Message 4 (Nov 3, 2025) - Al
"thats enough of a solid potentially maybe for me"
- Threw it in proposal (due end of day)
- "If that one doesn't fly maybe there's another angle near by we can team up on"

### Message 5 (Jan 14, 2026) - Al
"Happy 2026!"
- Asking about Kennedy Siding concept AND THUT15000 Deactivation
- Options to use 2024-25 dollars before end of March
- Otherwise do it all in 2025-26

### Message 6 (Jan 14, 2026) - Stephanie
"I am in all-day meetings all week (yaaay)"
- Gave Andy's number: 250 649-2860
- "he has some updates for you I am sure"

### Message 7 (Jan 14, 2026) - Andy (KEY UPDATE)
**THUT 15000:** "The culvert has been pulled (see picture) and deactivated."

**Kennedy Siding:** "Looking at the Kennedy Siding as a 2026 project but need to prepare a site plan for a new structure. Looking like a 15m bridge but may be tricky with the alignment."

"Feel free to give me a shout after lunch for more details"

### Message 8 (Jan 14, 2026) - Al
"Maybe I just assume we are riding into 2026"

---

## Key Takeaways for Reply

1. **THUT 15000 is done** - culvert pulled, deactivated. Andy knows this. Don't explain.
2. **Kennedy Siding is progressing** - 2026 project, 15m bridge planned, alignment tricky. THIS IS GOOD NEWS.
3. **Stephanie in meetings all week** - casual acknowledgment
4. **Tone throughout** - informal, casual ("snowballs chance in Mexico", "solid potentially maybe")
5. **What to focus on** - our hope to do enhancement work at the THUT 15000 sites (soil decompaction, riparian planting, CWD) - the "above minimum standards" stuff from the proposal

---

## Project Context from Proposal

### Nation River Deactivation Sites
- **Modelled Crossing IDs:** 15201563 and 15201146
- **Location:** Tributaries to Nation River
- **Status:** BCTS completed culvert removals in fall 2025 to minimum standards
- **Assessments completed before removal:**
  - Fish passage assessments at both sites
  - Habitat confirmation at one site
  - eDNA sampling at one site
- **Proposed 2026/27 work:** Restoration above minimum standards
  - Soil decompaction
  - Riparian planting
  - Coarse woody debris placement

### Kennedy Siding / PSCIS 199663
- **Location:** Tributary to Parsnip River on CHCO 11000 FSR
- **Status:** Working with BCTS to review and explore replacement
- **Timing:** Replacement may occur summer 2026 or across 2026-27 and 2027-28 fiscal years

---

## gmailr Workflow Notes

### Authentication Setup
1. OAuth credentials at: `/Users/airvine/Projects/repo/gmailr/quickstart/credentials.json`
2. Environment variable in `~/.Renviron`: `GMAILR_OAUTH_CLIENT`
3. Authenticate interactively in RStudio, token gets cached
4. Command line can then use cached token

### Searching & Reading Emails
```r
gmailr::gm_auth(email = 'al@newgraphenvironment.com')

# Search messages
msgs <- gmailr::gm_messages(search = 'from:Andrew.Upson@gov.bc.ca subject:Kennedy Siding')

# Get thread
thread <- gmailr::gm_thread('thread_id_here')
msgs <- thread$messages

# Get message details
gmailr::gm_from(msg)
gmailr::gm_to(msg)
gmailr::gm_date(msg)
gmailr::gm_subject(msg)
gmailr::gm_body(msg, type = 'text/plain')
```

### Sending Emails (gmailr - supports threading)
```r
msg <- gmailr::gm_mime() |>
  gmailr::gm_to(to_addr) |>
  gmailr::gm_from("al@newgraphenvironment.com") |>
  gmailr::gm_cc(cc_addr) |>
  gmailr::gm_subject("Subject line") |>
  gmailr::gm_html_body(email_body)

# Send as new email
gmailr::gm_send_message(msg)

# Send as reply in thread
gmailr::gm_send_message(msg, thread_id = "thread_id_here")
```

### Test Mode Pattern
```r
test_mode <- TRUE

if (test_mode) {
  to_addr <- "al@newgraphenvironment.com"
  cc_addr <- NULL
} else {
  to_addr <- "actual@recipient.com"
  cc_addr <- c("cc1@example.com", "cc2@example.com")
}

# Send - no thread in test mode
if (test_mode) {
  gmailr::gm_send_message(msg)
} else {
  gmailr::gm_send_message(msg, thread_id = thread_id)
}
```
