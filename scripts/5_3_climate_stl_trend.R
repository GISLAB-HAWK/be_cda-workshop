# Timeseries request and calculate STL based linear climate trend.

# load tubedb
source('scripts/0_init.R')

location <- 'SEG41'

# get climate time series of one sensor at one plot
tsDF <- rTubeDB::query_timeseries(
  tubedb, 
  plot=c(location), 
  sensor=c('Ta_200'), 
  quality = 'empirical', 
  aggregation = 'day', 
  interpolated = TRUE, 
  datetimeFormat='POSIXlt'
)

# remove NAs at the beginning and end
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

# sensonality decomposition by year (integer needed)
frequency <- 365

ts_obj <- ts(tsDF$Ta_200, frequency = frequency)

# STL decomposition
decomp <- stl(ts_obj, s.window = "periodic", robust = TRUE)
trend_dt <- data.frame(
  datetime = tsDF$datetime,
  trend    = as.numeric(decomp$time.series[, "trend"])
)
trend_dt <- na.omit(trend_dt)
fit <- lm(trend ~ datetime, data = trend_dt)
summary(fit)

# draw diagram of timeseries
plot(
  tsDF$datetime, 
  tsDF$Ta_200, 
  type = 'l', 
  col = 'grey50',
  xlab = 'Date', 
  ylab = 'Ta_200 °C', 
  main = paste0(location, ' Ta_200')
)

# add STL trend to diagram
lines(
  trend_dt$datetime, 
  trend_dt$trend, 
  col = 'blue', 
  lwd = 2
)

# add linear trend to diagram
lines(
  trend_dt$datetime, 
  fitted(fit), 
  col = 'red', 
  lwd = 2, 
  lty = 2
)

# add linear trend slope number
slope_per_sec  <- coef(fit)['datetime']  
slope_per_year <- slope_per_sec * 365.24 * 24 * 3600
slope_label <- sprintf('Temperature trend: %+.2f °K per year', slope_per_year)
mtext(slope_label, side = 3, line = 1.2, adj = 0, cex = 0.9, font = 3)

# subset trend without data before 2014
trend_dt_2014 <- trend_dt[as.Date(trend_dt$datetime) >= as.Date("2014-01-01"), ]

# calculate 2014 linear trend from STL trend
fit_2014 <- lm(trend ~ datetime, data = trend_dt_2014)

# predict 2014 linear trend to full time range
trend_2014_full <- predict(fit_2014, newdata = trend_dt)

# add 2014 linear trend to diagram
lines(
  trend_dt$datetime,
  trend_2014_full,
  col = 'darkgreen',
  lwd = 2,
  lty = 3
)

# add diagram legend
legend(
  'topright',
  legend = c('Ta_200', 'STL Trend', 'Trend linear', 'Trend linear 2014+'),
  col    = c('grey50', 'blue', 'red', 'darkgreen'),
  lty    = c(1, 1, 2, 3),
  lwd    = c(1, 2, 2, 2),
)

# add 2014 linear trend slope number
slope_per_sec_2014  <- coef(fit_2014)['datetime']
slope_per_year_2014 <- slope_per_sec_2014 * 365.24 * 24 * 3600
slope_label_2014 <- sprintf('Temperature trend since 2014: %+.2f °K per year', slope_per_year_2014)
mtext(slope_label_2014, side = 3, line = 0.2, adj = 0, cex = 0.9, font = 3)

# Timeseries of residuals: if there is a pattern, linearity is questionable
plot(trend_dt$datetime, residuals(fit), type = 'l', main = 'Residuals')
abline(h = 0, col = 'red', lty = 2)