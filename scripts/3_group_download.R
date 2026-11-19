# Obtain climate timeseries from all locations in one area.
#
# Group timeseries request, download an save to file.

# load tubedb
source('scripts/0_init.R')

# data output path
timeseries_path <- paste0(data_path, 'timeseries/')
if(!dir.exists(timeseries_path)) {
  dir.create(timeseries_path, recursive=TRUE)
}

# get plots of one region as data.frame
plotDF <- rTubeDB::query_region_plots(tubedb, 'BE')

# get all plots from plot group 'SEG'
segDF <- subset(plotDF, general_station == 'SEG')

# get plot names
plots <- segDF$id

sensors <- c('Ta_200', 'Ts_10')

tsDF <- rTubeDB::query_timeseries(
  tubedb, 
  plot=plots, 
  sensor=sensors, 
  aggregation = 'day', 
  datetimeFormat='POSIXlt',
  start = '2024',
  end = '2025',
  quality = 'empirical',
  interpolated = FALSE,
)

# write time series to file
rTubeDB::write_timeseries(
  tsDF, 
  paste0(timeseries_path, 'timeseries__SEG__Ta_200__Ts_10.csv')
)

# get timeseries at SEG41 only
seg01TsDF <- subset(tsDF, plot == 'SEG41')

# show timeseries diagram
plot(
  seg01TsDF$datetime, 
  seg01TsDF$Ta_200,
  type = 'l', 
  col = 'red',
  xlab = 'Date', 
  ylab = 'Temperature (°C)',
  main = 'SEG41 – Ta_200 and Ts_10'
)

# add Ts_10 line
lines(
  seg01TsDF$datetime, 
  seg01TsDF$Ts_10, 
  col = 'blue'
)

# add legend
legend(
  'topright', 
  legend = c('Ta_200', 'Ts_10'),
  col = c('red', 'blue'), 
  lty = 1
)









