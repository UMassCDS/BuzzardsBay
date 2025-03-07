# README for QC_codes

This file is used in stitch_site to reject data based on `Gen_QC` or `<metric>_QC`. Columns are:

1. `QC_Code` - the value of `Gen_QC` or `<metric>_QC`
2. `Rejection` - rejection action; possible values are
- `NA` - throw an error if found
- `0` - do not reject
- `1` - reject value: set to DR in WPP result file, and NA in core result file
- `2` - fatal: stop processing with an informative error
3. `Description` - text description of the `*_QC` value