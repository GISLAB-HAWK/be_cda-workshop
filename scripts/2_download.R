# Obtain climate timeseries from one location.
#
# Timeseries request, download and save to file.

# load tubedb
source('scripts/0_init.R')

# data output path
timeseries_path <- paste0(data_path, 'timeseries/')
if(!dir.exists(timeseries_path)) {
  dir.create(timeseries_path, recursive=TRUE)
}

# get climate time series of two sensors over two plots with default processing at full time span as data.frame
tsDF <- rTubeDB::query_timeseries(tubedb, plot=c('HEG01'), sensor=c('Ta_200', 'rH_200'), quality = 'empirical', aggregation = 'day', datetimeFormat='POSIXlt')
write.csv(tsDF, paste0(timeseries_path, 'timeseries__HEG01__Ta_200__rH_200.csv'), row.names = FALSE, quote = FALSE)

# show time series
plot(tsDF$datetime, tsDF$Ta_200)
