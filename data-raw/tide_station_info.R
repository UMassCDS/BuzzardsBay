## code to prepare "tide_station_info" containing information on the
## locations of tide stations in buzzard's bay

# Tab delimited text copied from:
# https://tidesandcurrents.noaa.gov/tide_predictions.html?gid=1403

tide_station_info <-
  "Name	Id	Lat	Lon	Predictions
Penikese Island	8448248	+41.4500	-70.9217	Harmonic
Chappaquoit Point, West Falmouth Harbor	8447685	+41.6050	-70.6517	Harmonic
Monument Beach	8447355	+41.7150	-70.6167	Subordinate
Gray Gables	8447295	+41.7350	-70.6233	Harmonic
Cape Cod Canal, RR. bridge	8447270	+41.7417	-70.6167	Harmonic
Onset Beach, Onset Bay	8447277	+41.7417	-70.6583	Subordinate
Great Hill	8447368	+41.7117	-70.7150	Harmonic
Marion, Sippican Harbor	8447385	+41.7050	-70.7617	Subordinate
Piney Point	8447416	+41.6950	-70.7200	Harmonic
Mattapoisett, Mattapoisett Harbor	8447531	+41.6567	-70.8133	Subordinate
New Bedford, Clarks Point	8447712	+41.5933	-70.9000	Harmonic
New Bedford Harbor, Marine Terminal	8447636	+41.6212	-70.9137	Harmonic
Round Hill Point	8447842	+41.5383	-70.9283	Harmonic
Gay Head, MA\t8448733\t+41.3533\t-70.83\tNA
Martha's Vineyard GPS Buoy	8448875	+41.3262	-70.5903	Harmonic
" |>   # last two manually added
  readr::read_tsv(show_col_types = FALSE) |>
  as.data.frame()

names(tide_station_info) <- tolower(names(tide_station_info))

# Wrapper to rtides lookup function that returns NA when station isn't found -
# instead of throwing an erro
lookup_station <- function(name) {
  rtide_name <- NA
  tryCatch(rtide_name <- rtide::tide_stations(name), error = function(e) e)
  rtide_name
}

sites <- system.file("extdata/sites.csv", package = "BuzzardsBay") |>
  readr::read_csv()

# Verify that all the station IDs used in site_info.csv are in this table
missing_ids <- setdiff(sites$tide_station, tide_station_info$id)
stopifnot(length(missing_ids) == 0)


tide_station_info$used <- tide_station_info$id %in% sites$tide_station

# Manually search for missing stations
rts <- rtide::tide_stations() # rtide stations
grep("Buoy", rts, value = TRUE, ignore.case = TRUE)
grep("Martha", rts, value = TRUE, ignore.case = TRUE)

tide_station_info$rtide_name <-
  sapply(tide_station_info$name, lookup_station) |> as.character()





usethis::use_data(tide_station_info, overwrite = TRUE, internal = FALSE)
