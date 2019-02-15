##CHECK OUT CONFIG and KEYRING PACKAGE FOR SECURITY! AND ODBC PACAKGE FOR CONNECT TO OTHER DB
library(RMySQL)
library(DBI)
library(tibble)
library(lubridate)
library(rmarkdown)
library(ggplot2)
library("rmdformats")
Sys.setenv(RSTUDIO_PANDOC="/Applications/RStudio.app/Contents/MacOS/pandoc")
con = dbConnect(MySQL(), user='kunder@n148738', password='aqwsde@123', dbname='norquant_no', host='mysql334.loopia.se')

#Save objects to .rdata file
#skattelister <- rbind(ostfold,akershus,oslo,hedmark,oppland,buskerud,vestfold,telemark,aust_agder,vest_agder,rogaland,hordaland,sogn,more,sor_trond,nord_trond,nordland,troms,finnmark)

#This will return a list of the tables in our connection.
dbListTables(con)

#This will return a list of the fields in some_table.
dbListFields(con, 'KUNDELISTE')

#To retrieve data from the database we need to save a results set object.
data = dbGetQuery(con, "SELECT * FROM `KUNDELISTE`")

dbGetQuery(con, "ALTER TABLE `KUNDELISTE` ADD PRIMARY KEY ('row_names')")

dbSendQuery(con, "ALTER TABLE `KUNDELISTE`
CHANGE COLUMN row_names row_names INT AUTO_INCREMENT PRIMARY KEY")



#Close all connection
lapply( dbListConnections(MySQL()), dbDisconnect)



################################################################################
################################################################################
################################################################################
#This will return a list of the fields in some_table.
dbWriteTable(con, name='KUNDELISTE1', value=skattelister1)