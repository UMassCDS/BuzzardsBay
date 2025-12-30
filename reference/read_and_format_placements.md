# Read and format placements

Read and format placements

## Usage

``` r
read_and_format_placements(placement_path)
```

## Arguments

- placement_path:

  path to placements file

## Value

placement data_frame In addition to reading the file the following
changes are made:

- column names headers are forced to lower case,

- dates are formatted as dates while handling both the `yyyy-mm-dd`
  format and the format that excel converts them to.

- `type` is forced to lower case.
