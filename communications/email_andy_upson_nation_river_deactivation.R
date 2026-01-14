# Email to Andy Upson re: Tributary to Nation River deactivation sites context
# Pre-call briefing on FWCP fish passage restoration work

# Build the email
email <- blastula::compose_email(

  body = blastula::md(glue::glue(
    "
Hi Andy,

Thanks for the update. Great to hear Kennedy Siding is shaping up as a 2026 project - 15m bridge sounds solid even with the alignment challenges. Stoked that one's moving.

Appreciate Stephanie pointing me your way while she's in meeting purgatory all week.

Re the THUT 15000 sites - nice work getting those pulled. What we're keen on now is partnering on some enhancement work above the standard deactivation. Our 2026/27 FWCP proposal has dollars earmarked to do things like soil decompaction, riparian planting, and CWD placement at those spots. Idea is to bump up the fish habitat outcomes beyond the minimum - could be a good template for future collabs.

Sounds like riding into 2026 makes sense for all of it.

I'll call in 15.

Cheers,

Al

Al Irvine B.Sc., R.P.Bio.<br>
New Graph Environment Ltd.<br>
<br>
Cell: 250-777-1518<br>
Email: al@newgraphenvironment.com<br>
Website: www.newgraphenvironment.com
"
  ))
)

# Preview the email
email

# Send the email
email |>
  blastula::smtp_send(
    from = "al@newgraphenvironment.com",
    cc = c("info@newgraphenvironment.com", "Stephanie.Sundquist@gov.bc.ca"),
    # to = "al@newgraphenvironment.com",
    to = "Andrew.Upson@gov.bc.ca",
    subject = "RE: FWCP Fish Passage - Kennedy Siding - trib to Parsnip River - PSCIS 199663 - CHCO 11000",
    credentials = blastula::creds_key(id = "gmail")
  )
