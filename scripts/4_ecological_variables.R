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
tsDF <- rTubeDB::query_timeseries(tubedb, plot=c('HEG01'), sensor=c('Ta_200_growing_degree_days_10', 'Ta_200_heat_index', 'Ta_200_ice_days'), quality = 'empirical', aggregation = 'month', datetimeFormat='POSIXlt')
write.csv(tsDF, paste0(timeseries_path, 'timeseries__HEG01__eco.csv'), row.names = FALSE, quote = FALSE)

# show time series
plot(tsDF$datetime, tsDF$Ta_200_growing_degree_days_10)


# get one huge metadata object
meta <- rTubeDB::query_region_metadata(tubedb, 'BE')

meta$sensors[['Ta_200_growing_degree_days_10']]

meta$sensors[['Ta_200_heat_index']]

meta$sensors[['Ta_200_ice_days']]
