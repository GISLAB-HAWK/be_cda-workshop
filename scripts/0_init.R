# Install TubeDB R-package and open tubedb  connection.


# Install rTubeDB package and automatically install updated versions.
# In some cases a restart of R is needed to work with a updated version of rTubeDB package (in RStudio - Session - Terminate R).
if(!require('remotes')) install.packages('remotes')
if(!require('httr')) install.packages('httr')
if(!require('jsonlite')) install.packages('jsonlite')
remotes::install_github('environmentalinformatics-marburg/tubedb/rTubeDB')


# load package
library(rTubeDB)


#show rTubeDB package documentation
?TubeDB


# open TubeDB server connection by url, user and password
#url <- 'http://127.0.0.1:8080'
#user <- 'user'
#password <- 'password'
#tubedb <- rTubeDB::TubeDB(url = url, user = user, password= password)


# open TubeDB server connection by accounts file
if(!require('yaml')) install.packages('yaml')
accounts_file_path <- paste0(getwd(), '/', 'accounts.yaml')
accounts_file_template_path <- paste0(getwd(), '/', 'accounts_template.yaml')
if(!file.exists(accounts_file_path)) {
  warning('Missing accounts file at ', accounts_file_path, '\n', 'You may start by copying the template file ', accounts_file_template_path, ' to ', accounts_file_path, '\n and insert there your usernames and passwords.')
}
accounts <- yaml::read_yaml(accounts_file_path)
rm(accounts_file_path, accounts_file_template_path)
tubedb <- rTubeDB::TubeDB(url=accounts$tubedb$url, user=accounts$tubedb$user, password=accounts$tubedb$password)
rm(accounts)


# output path for data
data_path <- paste0(getwd(), '/data/')
if(!dir.exists(data_path)) {
  dir.create(data_path, recursive=TRUE)
}
