
# This achieves two things:
#
# 1.  Copies data from another site and subsitutes in the site names
#   and updates the times to correspond to the tide rider times.
# 2. Thins out the tide rider data to have a single reading every second.
# The end result is a new test deployment in 2024 WFH that has calibrated
# data (copied from a different deployment) and tide rider data.
#
#  The full example tide rider dataset has many data points with
# variable frequency but often a few seconds apart.  I excluded it from
# the repository because it's way to big.
# This code won't run without it but shouldn't need to be re-run.
# Hopefully we'll get new tide rider data soon with concurrent real
# DO and Cond. data; and we can drop this fake data.

tr_file <-
  "inst/extdata/2024/WFH/2024-04-09/Calibrated/RAW-TR_WFH_20240409_TRSX01.csv"
tr <- readr::read_csv(tr_file)

s_dir <- system.file(
  "extdata/2024/BD1/2024-06-21/Calibrated",
  package = "BuzzardsBay")
s_site <- "BD1"
s_date <- "2024-06-21"
d_site <- "WFH"
d_date <- "2024-04-09"

# Dates with underscores
usd <- gsub("-", "_", s_date) # underscore source date
udd <- gsub("-", "_", d_date)


# Sparsify the Tide Rider locations (to keep files small
sparse_times <- seq(from = lubridate::as_datetime("2024-04-09 11:50:00"),
                to = lubridate::as_datetime("2024-04-10 21:55:00"),
                by = lubridate::as.difftime(5, units = "mins"))

# Interpolate continuous variables
lat <- approx(x = tr$Time, y = tr$Latitude, xout = sparse_times)$y
lon <- approx(x = tr$Time, y = tr$Longitude, xout = sparse_times)$y
depth <- approx(x = tr$Time, y = tr$`Depth (m)`, xout = sparse_times)$y
tr2 <- data.frame(Time = sparse_times, Latitude = lat, Longitude = lon,
                  `Depth` = depth)
names(tr2)[4] <- "Depth (m)"

# Find closest value for Flags
t1 <- tr$Time[-nrow(tr)]
t2 <- tr$Time[-1]
breaks <-  t1 + (t2 - t1) / 2
intv <- findInterval(sparse_times, breaks, left.open = TRUE) + 1
tr2$Flags <- tr$Flags[intv]
rm(s1, s2, breaks, intv)


# List of source file paths (from)
l <- list.files(s_dir, full.names = TRUE)
from <- list(do = grep("DO[^/\\\\]*\\.csv$", l, value = TRUE),
             do_det = grep("DO[^/\\\\]*Details.txt$", l, value = TRUE),
             cond  = grep("Cond[^/\\\\]*\\.csv$", l, value = TRUE),
             cond_det = grep("Cond[^/\\\\]*Details.txt$", l, value = TRUE))

# List of destination file paths (to)
to <- from
to <- lapply(to, function(x) gsub(s_site, d_site, x))
to <- lapply(to, function(x) gsub(s_date, d_date, x))
to <- lapply(to, function(x) gsub(usd, udd, x))


# Edit dates in new files
det <- parse_hoboware_details(from$do_det)

do <- readr::read_csv(from$do)
old_times <- do$`Date Time`
do <- do[seq_len(nrow(tr2)), ]
do$`Date Time` <- tr2$Time
readr::write_csv(do, file = to$do)

cond <- readr::read_csv(from$cond)
cond <- cond[seq_len(nrow(tr2)), ]
cond$`Date Time` <- tr2$Time
readr::write_csv(cond, to$cond)


times <- paste0(format(tr2$Time, "%m/%d/%Y %I:%M:%S %p"), " GMT-04:00")
new_start_time <- times[1]
new_end_time <- times[length(times)]

old_start_time <- det$Series_DO_Adj_Conc_mg_per_L$Deployment_Info$Launch_Time
old_end_time <- det$Event_Type_Stopped$Series_Statistics$Last_Sample_Time

# Write modified tide ride data
dest_tr_file <- gsub("/RAW-", "/", tr_file)
readr::write_csv(tr2, dest_tr_file)

# Process the details files subbing in the new site name, and start and end times
for (i in seq_len(2)) {
  det <- readLines(c(from$do_det, from$cond_det)[i])
  det <- gsub(s_site, d_site, det)
  det <- gsub(old_start_time, new_start_time, det, fixed = TRUE)
  det <- gsub(old_end_time, new_end_time, det, fixed = TRUE)
  writeLines(det, c(to$do_det, to$cond_det)[i])
}
