## code to prepare "tide_station_info" containing information on the
## locations of tide stations in buzzard's bay

# Tab delimited text copied from:
# https://tidesandcurrents.noaa.gov/tide_predictions.html?gid=1403

tide_station_info <- "Name	Id	Lat	Lon	Predictions
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
Clarks Point	8447712	+41.5933	-70.9000	Harmonic
New Bedford Harbor, Marine Terminal	8447636	+41.6212	-70.9137	Harmonic
Round Hill Point	8447842	+41.5383	-70.9283	Harmonic"  |>
  readr::read_tsv() |>
  as.data.frame()

names(tide_station_info) <- tolower(names(tide_station_info))

usethis::use_data(tide_station_info, overwrite = TRUE)

