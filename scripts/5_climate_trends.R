# Timeseries request, download an save to file.

# load tubedb
source('scripts/0_init.R')

# data output path
timeseries_path <- paste0(data_path, 'timeseries/')
if(!dir.exists(timeseries_path)) {
  dir.create(timeseries_path, recursive=TRUE)
}

# get climate time series of two sensors over two plots with default processing at full time span as data.frame
tsDF <- rTubeDB::query_timeseries(tubedb, plot=c('HEG01'), sensor=c('Ta_200'), quality = 'empirical', aggregation = 'day', interpolated = TRUE, datetimeFormat='POSIXlt')

first_valid <- min(which(complete.cases(tsDF$Ta_200)))
last_valid <- max(which(complete.cases(tsDF$Ta_200)))
tsDF <- tsDF[first_valid:last_valid, ]

# show time series
plot(tsDF$datetime, tsDF$Ta_200)

frequency <- 365.24
ts_obj <- ts(tsDF$Ta_200, frequency = frequency)
decomp <- decompose(ts_obj)


trend_dt <- data.frame(datetime = tsDF$datetime, trend = decomp$trend)
trend_dt <- na.omit(trend_dt)

fit <- lm(trend ~ datetime, data = trend_dt)
summary(fit)


plot(
  tsDF$datetime, 
  tsDF$Ta_200, 
  type = 'l', 
  col = 'grey50',
  xlab = 'Date', 
  ylab = 'Ta_200', 
  main = 'HEG01 Ta_200'
)


lines(
  trend_dt$datetime, 
  trend_dt$trend, 
  col = 'blue', 
  lwd = 2
)


lines(
  trend_dt$datetime, 
  fitted(fit), 
  col = 'red', 
  lwd = 2, 
  lty = 2
)


legend(
  'topright',
  legend = c('Ta_200', 'Trend', 'Trend linear'),
  col    = c('grey50', 'blue', 'red'),
  lty    = c(1, 1, 2),
  lwd    = c(1, 2, 2)
)



slope_per_sec  <- coef(fit)['datetime']  
slope_per_year <- slope_per_sec * 365.24 * 24 * 3600

slope_label <- sprintf('Temperature trend: %+.2f °C per year', slope_per_year)

mtext(slope_label, side = 3, line = 0.2, adj = 0, cex = 0.9, font = 3)
