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

# get all plots from plot group 'HEG'
hegDF <- subset(plotDF, general_station == 'HEG')

# get plot names
plots <- hegDF$id

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
write.csv(tsDF, paste0(timeseries_path, 'timeseries__HEG__Ta_200__Ts_10.csv'), row.names = FALSE, quote = FALSE)

# get timeseries at HEG01 only
heg01TsDF <- subset(tsDF, plot == 'HEG01')

# show timeseries diagram
plot(
  heg01TsDF$datetime, 
  heg01TsDF$Ta_200,
  type = 'l', 
  col = 'red',
  xlab = 'Date', 
  ylab = 'Temperature (°C)',
  main = 'HEG01 – Ta_200 and Ts_10'
)

lines(
  heg01TsDF$datetime, 
  heg01TsDF$Ts_10, 
  col = 'blue'
)

legend(
  'topleft', 
  legend = c('Ta_200', 'Ts_10'),
  col = c('red', 'blue'), 
  lty = 1
)









