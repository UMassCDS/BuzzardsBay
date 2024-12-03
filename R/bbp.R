# This is an environment within the package namespace that can
# hold globabl parameters, like all other package objects it is
# immutable after the package is loaded.
# However, its contents are NOT
# Environmental also are a reference to a bunch of objects in memory which
# means changing the environment contents changes it everywhere, analagous to
# passing a reference with C++.
# For instance if we make  a function that we pass the environment too and that
# function changes something in the environment, than that change is preserved
# anywhere we use that environment even if the function doesn't return anything.
# The bbp object is not public but see `bb_options()`.

bbp <- new.env()

# Immediate rejection check parameters

bbp$logger_error_values <- -888.88

# TDl/TCl  (Low temperature)
bbp$min_temp <- 5

# TDh/TCh (High temperature)
bbp$max_temp <- 35

# Hl  (Low high range)
bbp$min_hr <- 1000

# Hh  (High high range)
bbp$max_hr <- 55000

# Rh  (High Raw DO)
bbp$max_raw_do <- 20


# Other flag parameters

default_lv_range <- .01 # default low variation range, used for all variable
default_lv_duration <- 60 # default duration of low variation streak, note
# the streak must be longer than this duration.  Thus setting it to 60 minutes
# with an interval of 10 minutes indicates that we'd need 7 consecutive
# readings within which the max value - min values is consistently less than
# This is based on "Longer than an hour"


# Dls (Dissolved oxygen low streak)
# (Flag if the DO is below the min for at least the length)
bbp$do_streak_min  <- 0.5 # Streak minimum DO
bbp$do_streak_duration <- 60  # Minutes, a streak must be longer than this many
#                               minutes to qualify,

# Dj  (Dissolved oxygen jump)
bbp$do_max_jump <- 2 # Flag if DO jumps by more than this between observations

# Dlv (Low variation in dissolved oxygen)
bbp$do_lv_range <- default_lv_range
bbp$do_lv_duration <- default_lv_duration


# Sj  (Salinity jump)
bbp$sal_max_jump <- 0.75

# Salinity low variation
bbp$sal_lv_range <- default_lv_range
bbp$sal_lv_duration <- default_lv_duration


## Range limits used to constrain plot Y axis
bbp$plot_min_do <- 0
bbp$plot_max_do <- 20
bbp$plot_min_sal <- 0
bbp$plot_max_sal <- 100
bbp$plot_min_temp <- 25
bbp$plot_max_temp <- 35


# The values here are defaults - save a copy to reset defaults later
default_bbp <- as.environment(as.list(bbp, all.names = TRUE))
