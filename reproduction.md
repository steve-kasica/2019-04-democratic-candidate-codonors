# Reproduction in Roundup

## Pre-roundup

1. Upload the 15 filings tables all (4 x 1), named by filing id, e.g. 1326465. I'm assuming that they have been converted already from `.fec` to `.csv`.
2. Combine 15 filings tables into a _stack_ operation, Stack-1.
3. Upload 1 candidates table, `candidates.csv` (4 x 15).

# Roundup

1. Upload all filings files `1326*.csv`, `filings.csv`, and `candidates.csv` into Roundup.
2. Stack individual filings `1326*` into a single table, `filings`.
3. Pack `filings` and `candidates` into a single table, `filings.candidates`, using `candidate_id` as the key.
