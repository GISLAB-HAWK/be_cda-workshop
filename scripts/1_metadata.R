# Obtain metadata about the Climate Stations.
#
# Query TubeDB metadata and write metadata to file.


# load tubedb
source('scripts/0_init.R')

# data output path
metadata_path <- paste0(data_path, 'metadata/')
if(!dir.exists(metadata_path)) {
  dir.create(metadata_path, recursive=TRUE)
}


# get regions/projects as data.frame
regionDF <- rTubeDB::query_regions(tubedb)
write.csv(regionDF, paste0(metadata_path, 'region.csv'), row.names = FALSE, quote = FALSE)

# get groups of plots as data.frame
groupDF <- rTubeDB::query_region_general_stations(tubedb, 'BE')
write.csv(groupDF, paste0(metadata_path, 'groups.csv'), row.names = FALSE, quote = FALSE)

# get plots of one region as data.frame
plotDF <- rTubeDB::query_region_plots(tubedb, 'BE')
write.csv(plotDF, paste0(metadata_path, 'plots.csv'), row.names = FALSE, quote = FALSE)

# get all sensors of all plots of one region as data.frame
sensorDF <- rTubeDB::query_region_sensors(tubedb, 'BE')
write.csv(sensorDF, paste0(metadata_path, 'sensors.csv'), row.names = FALSE, quote = FALSE)

# get one huge metadata object
meta <- rTubeDB::query_region_metadata(tubedb, 'BE')
writeLines(toJSON(meta, pretty = TRUE, auto_unbox = TRUE), paste0(metadata_path, 'meta.json'))


# get meta of one plot
meta$plots[['HEG01']]

# get plot position
meta$plots[['HEG01']]$latitude
meta$plots[['HEG01']]$longitude

# get meta of one sensor
meta$sensors[['Ta_200']]

# get sensor description
meta$sensors[['Ta_200']]$description

