# Obtain derived climate timeseries relevant to ecological processes.
#
# Timeseries with ecological index processing request, download an save to file.

# load tubedb
source('scripts/0_init.R')

# data output path
timeseries_path <- paste0(data_path, 'timeseries/')
if(!dir.exists(timeseries_path)) {
  dir.create(timeseries_path, recursive=TRUE)
}

# get climate time series of two sensors over two plots with default processing at full time span as data.frame
tsDF <- rTubeDB::query_timeseries(
  tubedb, 
  plot = c('SEG41'), 
  sensor = c('Ta_200_growing_degree_days_10', 'Ta_200_heat_index', 'Ta_200_ice_days'), 
  quality = 'empirical', 
  aggregation = 'month', 
  datetimeFormat = 'POSIXlt'
)

# write time series to file
rTubeDB::write_timeseries(tsDF, paste0(timeseries_path, 'timeseries__SEG41__eco.csv'))

# show time series
plot(tsDF$datetime, tsDF$Ta_200_growing_degree_days_10)


# get all sensors of all plots of one region as data.frame
sensorDF <- rTubeDB::query_region_sensors(tubedb, 'BE')

# subset sensor table with sensors derived from Ta_200
sensorDF_Ta_200 <- sensorDF[grepl("^Ta_200_", sensorDF$id) & sensorDF$derived == TRUE, ]
