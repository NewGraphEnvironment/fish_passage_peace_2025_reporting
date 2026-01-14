# Email to Andy Upson re: Tributary to Nation River deactivation sites context
# Pre-call briefing on FWCP fish passage restoration work
# Using gmailr to reply in-thread

# Authenticate
gmailr::gm_auth(email = "al@newgraphenvironment.com")

# Thread ID from existing conversation
thread_id <- "199d09983e25ad2c"

# --- MODE ---
# test_mode <- TRUE
test_mode <- FALSE

# Recipients based on mode
if (test_mode) {
  to_addr <- "al@newgraphenvironment.com"
  cc_addr <- NULL
} else {
  to_addr <- "Andrew.Upson@gov.bc.ca"
  cc_addr <- c("info@newgraphenvironment.com", "Stephanie.Sundquist@gov.bc.ca")
}

# Email body
email_body <- "
Hi Andy,
<br><br>
Thanks for the update. Great to hear Kennedy Siding is shaping up as a 2026 project - 15m bridge sounds solid even with the alignment challenges. It's great that one's moving.
<br><br>
Re the THUT 15000 sites - nice work getting those pulled. We're keen on partnering on some enhancement work above the standard deactivation. Our 2026/27 FWCP proposal has dollars earmarked to do things like soil decompaction, riparian planting, and CWD placement at those spots. Idea is to bump up the fish habitat outcomes beyond the minimum - could be a good template for future collabs.
<br><br>
2026 dollars probably makes sense for all of it.
<br><br>
I'll call in 15.
<br><br>
Cheers,
<br><br>
Al
<br><br>
Al Irvine B.Sc., R.P.Bio.<br>
New Graph Environment Ltd.<br>
<br>
Cell: 250-777-1518<br>
Email: al@newgraphenvironment.com<br>
Website: www.newgraphenvironment.com
"

# Build the mime message
msg <- gmailr::gm_mime() |>
  gmailr::gm_to(to_addr) |>
  gmailr::gm_from("al@newgraphenvironment.com") |>
  gmailr::gm_subject("RE: FWCP Fish Passage - Kennedy Siding - trib to Parsnip River - PSCIS 199663 - CHCO 11000") |>
  gmailr::gm_html_body(email_body)

# Add cc if set
if (!is.null(cc_addr)) {
  msg <- msg |> gmailr::gm_cc(cc_addr)
}

# Preview in RStudio viewer
# htmltools::html_print(htmltools::HTML(email_body))


# Send - reply in thread only in production mode
if (test_mode) {
  gmailr::gm_send_message(msg)
} else {
  gmailr::gm_send_message(msg, thread_id = thread_id)
}
