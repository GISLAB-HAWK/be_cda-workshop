# Calculate temperature trend from the measured timeseries at one location.
#
# Based on years
#
# Timeseries request and calculate year based linear climate trend.

# load tubedb
source('scripts/0_init.R')

location <- 'SEG41'

# get climate time series of one sensor at one plot
tsDF <- rTubeDB::query_timeseries(
  tubedb, 
  plot=c(location), 
  sensor=c('Ta_200'), 
  quality = 'empirical', 
  aggregation = 'year', 
  interpolated = TRUE, 
  datetimeFormat='POSIXlt',
  colYear = TRUE
)

# show time series
#plot(tsDF$datetime, tsDF$Ta_200)

# fit linear model to year time series
tsDF_clean <- na.omit(tsDF)
fit <- lm(Ta_200 ~ year, data = tsDF_clean)
summary(fit)
tsDF$trend <- predict(fit, newdata = tsDF)

# draw diagram of timeseries
plot(
  tsDF$year, 
  tsDF$Ta_200, 
  type = 'l', 
  col = 'grey50',
  xlab = 'Date', 
  ylab = 'Ta_200 °C', 
  main = paste0(location, ' Ta_200')
)

# add linear trend to diagram
lines(
  tsDF$year, 
  tsDF$trend, 
  col = 'red', 
  lwd = 2, 
  lty = 2
)

# add linear trend slope number
slope_per_year  <- coef(fit)['year']  
slope_label <- sprintf('Temperature trend: %+.2f °K per year', slope_per_year)
mtext(slope_label, side = 3, line = 1.2, adj = 0, cex = 0.9, font = 3)


# subset to trend without data before 2014
tsDF_subset <- tsDF_clean[tsDF_clean$year >= 2014, ]
fit_subset <- lm(Ta_200 ~ year, data = tsDF_subset)
summary(fit_subset)
tsDF$trend_subset <- predict(fit_subset, newdata = tsDF)


# add 2014 linear trend to diagram
lines(
  tsDF$year, 
  tsDF$trend_subset,
  col = 'darkgreen',
  lwd = 2,
  lty = 3
)

# add diagram legend
legend(
  'topright',
  legend = c('Ta_200', 'Trend linear', 'Trend linear 2014+'),
  col    = c('grey50', 'red', 'darkgreen'),
  lty    = c(1, 2, 3),
  lwd    = c(1, 2, 2),
)

# add 2014 linear trend slope number
slope_per_year_2014  <- coef(fit_subset)['year']
slope_label_2014 <- sprintf('Temperature trend since 2014: %+.2f °K per year', slope_per_year_2014)
mtext(slope_label_2014, side = 3, line = 0.2, adj = 0, cex = 0.9, font = 3)

# Timeseries of residuals: if there is a pattern, linearity is questionable
#plot(tsDF_clean$year, residuals(fit), type = 'l', main = 'Residuals')
#abline(h = 0, col = 'red', lty = 2)



