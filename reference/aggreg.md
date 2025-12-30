# Improved version of aggregate

Improve on miserable `aggregate` function:

- ignore NAs

- return NA if all in group are Inf or NaN

- no warnings

- sort by grouping variable and optionally return only result column

- optionally drop groups with too many NAs

## Usage

``` r
aggreg(x, by, FUN, drop_by = TRUE, nomiss = NULL)
```

## Arguments

- x:

  Vector to aggregate

- by:

  Vector(s) to group by (if only 1 grouping variable, this doesn't have
  to be a list)

- FUN:

  Function to summarize with

- drop_by:

  If TRUE, drop the grouping variable and just return a vector;
  otherwise, return a data frame

- nomiss:

  If not NULL, this represents a proportion of the data in a group that
  must be non-missing; if this threshold isn't met, the result for the
  group will be NA

## Value

Vector of aggregated values (if drop_by = TRUE), or data frame of groups
and aggregated values (if drop_by = FALSE)
