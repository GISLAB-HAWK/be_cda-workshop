# Calculate temperature trend from the measured timeseries at one location.
#
# Based on months
#
# Timeseries request and calculate climate trend.

# load tubedb
source('scripts/0_init.R')

if(!require('trend')) install.packages('trend')

location <- 'SEG41'

tsDF <- rTubeDB::query_timeseries(
  tubedb, 
  plot=c(location), 
  sensor=c('Ta_200'), 
  quality = 'empirical', 
  aggregation = 'month', 
  interpolated = TRUE, 
  datetimeFormat='POSIXct',
  colMonth = TRUE,
  colYear = TRUE
)

# Remove NAs at the beginning and end
first_valid <- min(which(complete.cases(tsDF$Ta_200)))
last_valid  <- max(which(complete.cases(tsDF$Ta_200)))
tsDF <- tsDF[first_valid:last_valid, ]

# take largest time block without NA (needed if interpolation could not fill all gaps)
# ok <- !is.na(tsDF$Ta_200)
# r <- rle(ok)
# r$lengths[!r$values] <- 0 # Set NA to 0, to cumsum valid positions only
# i <- which.max(r$lengths)          # largest valid block
# end_idx <- sum(r$lengths[seq_len(i)])
# start_idx <- end_idx - r$lengths[i] + 1
# tsDF <- tsDF[start_idx:end_idx, ]

# show time series
#plot(tsDF$datetime, tsDF$Ta_200)

# timestamp with fraction of years
tsDF$t <- as.numeric(difftime(tsDF$datetime, tsDF$datetime[1], units = "days")) / 365.24

# mean value for any month (12 values)
mean_per_month <- tapply(tsDF$Ta_200, tsDF$month, mean, na.rm = TRUE)

# Difference mean_per_month from monthly data
tsDF$diff <- tsDF$Ta_200 - mean_per_month[tsDF$month]

# Trend slope per month, converted to per year
sen <- trend::sens.slope(tsDF$diff)
slope_per_year       <- sen$estimates["Sen's slope"] * 12
slope_lower_per_year <- sen$conf.int[1] * 12
slope_upper_per_year <- sen$conf.int[2] * 12

#2014 trend
tsDF_2014 <- tsDF[tsDF$year >= 2014, ]
tsDF_2014$diff <- tsDF_2014$Ta_200 - mean_per_month[tsDF_2014$month]
sen_2014 <- trend::sens.slope(tsDF_2014$diff)
slope_per_year_2014       <- sen_2014$estimates["Sen's slope"] * 12
slope_lower_per_year_2014 <- sen_2014$conf.int[1] * 12
slope_upper_per_year_2014 <- sen_2014$conf.int[2] * 12




# Year aggregation
tsDF_year <- aggregate(Ta_200 ~ year, data = tsDF, FUN = mean, na.rm = TRUE)
tsDF_year$datetime <- as.POSIXct(paste0(tsDF_year$year, "-07-01"), tz = "UTC")

# Centering for trend lines
mean_t  <- mean(tsDF$t)
mean_Ta <- mean(tsDF$Ta_200, na.rm = TRUE)

mean_t_2014  <- mean(tsDF_2014$t)
mean_Ta_2014 <- mean(tsDF_2014$Ta_200, na.rm = TRUE)

# draw diagram of timeseries
plot(
  tsDF$datetime, 
  tsDF$Ta_200, 
  type = 'l', 
  col = 'grey80',
  xlab = 'Date', 
  ylab = 'Ta_200 °C', 
  main = paste0(location, ' Ta_200')
)

# add year mean line
lines(tsDF_year$datetime, tsDF_year$Ta_200, col = 'blue', lwd = 2)

# add trend line
lines(
  tsDF$datetime,
  mean_Ta + slope_per_year * (tsDF$t - mean_t),
  col = 'red', lwd = 2, lty = 2
)

# add trend 2014 line
lines(
  tsDF$datetime,
  mean_Ta_2014 + slope_per_year_2014 * (tsDF$t - mean_t_2014),
  col = 'darkgreen', lwd = 2, lty = 3
)

# add diagram legend
legend(
  'topright',
  legend = c('Ta_200', 'Annual mean', 'Trend linear', 'Trend linear 2014+'),
  col    = c('grey80', 'blue', 'red', 'darkgreen'),
  lty    = c(1, 1, 2, 3),
  lwd    = c(1, 2, 2, 2),
)

# slope number
mtext(
  sprintf('Theil-Sen: %+.2f °C/year (conf.int %+.2f to %+.2f)',
          slope_per_year, slope_lower_per_year, slope_upper_per_year),
  side = 3, line = 1.2, adj = 0, cex = 0.9, font = 3
)
mtext(
  sprintf('Since 2014: %+.2f °C/year (conf.int %+.2f to %+.2f)',
          slope_per_year_2014, slope_lower_per_year_2014, slope_upper_per_year_2014),
  side = 3, line = 0.2, adj = 0, cex = 0.9, font = 3
)

