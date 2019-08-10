# Analysis of early 2020 Democratic campaign co-donors 

This repository contains data and code supporting a [BuzzFeed News article examining donors](https://www.buzzfeednews.com/article/tariniparti/democratic-donors-2020-candidates) who gave more than $200 to multiple Democratic presidential candidates in the first quarter of the 2020 election cycle, published April 16, 2019. See below for details.

## Steve's Notes

This notebook does an cool bit of deduplication in cell execution 14 to prevent double counting after a self join.

```
candidate_pairs = (
    contributor_totals
    .rename(columns = {
        "Candidate Name": "candidate"
    })
    [[
        "donor_id",
        "candidate"
    ]]
    .pipe(lambda df: (
        df
        .merge(
            df,
            how = "left",
            on = "donor_id",
            suffixes = [ "_x", "_y" ],
        )
    ))
    # This filter prevents us from double-counting candidate-combinations
    .loc[lambda df: df["candidate_x"] < df["candidate_y"]]
    .sort_values([
        "candidate_x",
        "candidate_y",
        "donor_id"
    ])
)
candidate_pairs.head(10)
```

## Data

All data in this repository comes from the campaigns' committee filings to the [Federal Election Commission](https://www.fec.gov/) (FEC), with assistance from [ProPublica's Campaign Finance API](https://projects.propublica.org/api-docs/campaign-finance/committees/#get-committee-filings). 

- [`inputs/candidates.csv`](inputs/candidates.csv) contains a list of high- and medium-profile Democratic presidential candidates (and primary campaign committees) for whom an "April Quarterly" filing was available on the FEC's website by 6:30am Eastern on April 16, 2019. (The filing deadline was April 15 at midnight.)

- [`inputs/filings.csv`](inputs/filings.csv) contains a list of basic metadata for the aforementioned filings.

- The [`inputs/filings/`](inputs/filings/) directory contains the raw filing data for each of those filings, in the FEC's `.fec` format.

## Methodology

### Linking donors

The Federal Election Commission filings do not contain any truly-unique identifiers for campaign contributors. So, in order identify donors who have given to multiple campaigns, BuzzFeed News constructed a `donor_id`, created from the following fields:

- First name
- Last name
- 5-digit ZIP code

There are some limitations to this approach:

- If a donor changes their name, or misspells it occasionally, this approach will not cluster all of their contributions together
- If a donor moves to a new ZIP code, this approach will not cluster all of their contributions together
- If two or more donors in the same ZIP code share both a first and last name, this approach will assume (incorrectly) that they are the same person

For these reasons, the results of the analysis should be interpreted as approximations.

### The $200 threshold

The Federal Election Commission does not require campaigns to itemize contributions from donors who have given **$200 or less** during a given campaign cycle. In a small number of cases, however, campaigns have included such donors — often, it seems, because they gave a large amount of money and then were refunded. For the sake of equal comparison, BuzzFeed News excluded contributions from donors whose aggregate was listed as $200 or less.

### Contribution totals above legal limit

The FEC prohibits individual donors from giving more than $2,800 to any single committee. Even so, the data in the filings appear to indicate that some donors have given more than that amount. In some cases, this may be because the refunds have not yet been processed, or are declared elsewhere. Above-legal contributions have no effect on the analyses, which focus on the act of giving rather than how much money the campaigns have raised.

## Analysis

The [`notebooks/analyze-campaign-codonors.ipynb`](notebooks/analyze-campaign-codonors.ipynb) notebook contains the analysis, written in Python. Relevant outputs can be found there, as well as in the [`outputs/`](outputs/) directory.

## Outputs

The [`outputs/`](outputs/) directory contains two files that may be of interest to other journalists and researchers:

- [`outputs/candidate-pair-counts.csv`](outputs/candidate-pair-counts.csv) counts the number of `donor_id`s that gave to each combination of **two** candidates.
- [`outputs/candidate-triplet-counts.csv`](outputs/candidate-triplet-counts.csv) counts the number of `donor_id`s that gave to each combination of **three** candidates.

In both files, combinations are not exclusive. For instance, someone who gave to four candidates will be counted for each permutation (i.e., six pairs and four triplets).

## Reproducibility

The code running the analysis is written in Python 3, and requires the following Python libraries:

- [pandas](https://pandas.pydata.org/) for data loading and analysis
- [fecfile](https://esonderegger.github.io/fecfile/) for parsing the raw FEC filings
- [jupyter](https://jupyter.org/) to run the notebook infrastructure

If you use Pipenv, you can install all required libraries with `pipenv install`.

Executing the notebook in the `notebooks/` directory should reproduce the findings.

## Licensing

All code in this repository is available under the [MIT License](https://opensource.org/licenses/MIT). Files in the `input/` directory are released into the public domain. Files in the `output/` directory are available under the [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/) (CC BY 4.0) license.

## Questions / Feedback

Contact Jeremy Singer-Vine at [jeremy.singer-vine@buzzfeed.com](mailto:jeremy.singer-vine@buzzfeed.com).

Looking for more from BuzzFeed News? [Click here for a list of our open-sourced projects, data, and code.](https://github.com/BuzzFeedNews/everything)
