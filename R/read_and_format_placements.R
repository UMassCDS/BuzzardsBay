
#' Read and format placements
#'
#' @param placement_path path to placements file
#'
#' @return placement data_frame
#' In addition to reading the file the following changes are made:
#' * column names headers are forced to lower case,
#' * dates are formatted as dates while handling both the `yyyy-mm-dd` format
#'  and the format that excel converts them to.
#' * `type` is forced to lower case.
#' @keywords internal
read_and_format_placements <- function(placement_path) {
  placements <- readr::read_csv(placement_path,
                                col_types = readr::cols(),
                                show_col_types = FALSE)
  placements$start_date <- format_csv_date(placements$start_date) |>
    lubridate::as_date()
  placements$end_date <- format_csv_date(placements$end_date) |>
    lubridate::as_date()
  names(placements) <- tolower(names(placements))
  placements$type <- tolower(placements$type)
  placements
}
