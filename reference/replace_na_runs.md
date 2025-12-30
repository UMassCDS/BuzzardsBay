# Replace short runs of NA in logical vector

Any runs of NA not longer than `max_run` that are surrounded by TRUE are
replaced with TRUE. All other NAs are replaced with FALSE.

## Usage

``` r
replace_na_runs(x, max_run = 6, boundary = FALSE)
```

## Arguments

- x:

  A logical vector that may have NAs

- max_run:

  The maximum run length to replace

- boundary:

  How to treat values beyond the edge of the data

## Value

A vector corresponding to `x` where qualifying runs have been replaced
with TRUE

## Details

Use `boundary` to specify behavior at data boundaries. For instance, if
boundary = TRUE, then c(NA, TRUE) would result in c(TRUE, TRUE);
otherwise the result would be c(FALSE, TRUE).
