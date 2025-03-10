# Interactive DO plot for debugging

library(dygraphs)


xxx <- read.csv('C:/Work/etc/COMBB_analysis/data/BB_Data/2024/AB2/combined/core_AB2_2024.csv')       # from my dir
# xxx <- read.csv(file.path(getwd(), 'BB_Data/2024/AB2/combined/core_AB2_2024.csv'))                        s# from temp dir

plot.data <- data.frame(date = as.POSIXct(xxx$Date_Time), DO = xxx$DO)

graph <- dygraph(plot.data, ylab = 'mg/L') |>
   dyOptions(connectSeparatedPoints = TRUE) |>
   dyAxis('x', gridLineColor = '#D0D0D0') |>
   dyAxis('y', gridLineColor = '#D0D0D0') |>
   dyCrosshair(direction = "vertical") |>
   dyLimit(6, color = 'green')

graph
s
