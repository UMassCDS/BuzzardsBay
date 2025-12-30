# Suppress some specific warnings

`suppress_specific_warnings()` will suppress warnings that match regular
expression patterns that are either coded into the function or supplied
via the `patterns` argument, without suppressing warnings that don't
match the patterns.

## Usage

``` r
suppress_specific_warnings(x, patterns = NULL)
```

## Arguments

- x:

  An expression.

- patterns:

  One or patterns to check warning messages against.

## Value

Possibly output from `x`

## Details

It's initial (possibly only) use is to catch a warning thrown by ggplot
due to NA value created by using lead() when plotting time of day.

`suppress_specific_warnings()` is used in the rmarkdown report so needs
to be a public function but it is not intended for external use.

## Examples

``` r
suppress_specific_warnings(warning("this is a warning"), "this is")
suppress_specific_warnings(warning("this is a warning"))
#> Warning: this is a warning
```
