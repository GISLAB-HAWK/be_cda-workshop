# Obtain climate timeseries from one location.
#
# Timeseries request, download and save to file and read back saved time series from file.

# load tubedb
source('scripts/0_init.R')

# data output path
timeseries_path <- paste0(data_path, 'timeseries/')
if(!dir.exists(timeseries_path)) {
  dir.create(timeseries_path, recursive=TRUE)
}

# get climate time series of two sensors over two plots with default processing at full time span as data.frame
tsDF <- rTubeDB::query_timeseries(tubedb, plot=c('SEG41'), sensor=c('Ta_200', 'rH_200'), quality = 'empirical', aggregation = 'day', datetimeFormat='POSIXlt')
filename <- paste0(timeseries_path, 'timeseries__SEG41__Ta_200__rH_200.csv')

# basic R CSV write function
#write.csv(tsDF, filename, row.names = FALSE, quote = FALSE)

# write time series to file
# checks existing datetime, does not write auxiliary columns  'year', 'month', 'day'
rTubeDB::write_timeseries(tsDF, filename)

# show time series
plot(tsDF$datetime, tsDF$Ta_200)

# read back saved timeseries CSV-file by basic R CSV read function
# datetime is character, needs to be converted to work with it.
tsDF2 <- read.csv(filename)

# read back saved timeseries CSV-file
# datetime is specified POSIXlt
# convenience columns are added to facilitate time based operations
# also per TubeDB web-interface exported time series can be read back
tsDF3 <- rTubeDB::read_timeseries(
  file = filename,
  datetimeFormat = 'POSIXlt',
  colYear = TRUE,
  colMonth = TRUE,
  colDay = TRUE,
  colHour = TRUE,
  colWeek = TRUE,
  colDayOfWeek = TRUE,
  colDayOfYear = TRUE,
  colMinute = TRUE
)