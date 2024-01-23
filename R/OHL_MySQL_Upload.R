#Version 1.6.1
# Created by Noah Cornish
# This file is used to upload dataframes to the MySQL server.


library(DBI)
library(RMariaDB)
library(tidyverse)

# source files to execute data frames
source('R Files/OHL_DraftYear_Stats.R')
source('R Files/OHL_EV_Stats.R')
source('R Files/OHL_Goalie_Stats.R')
source('R Files/OHL_Player_Stats.R')
source('R Files/OHL_Rookie_Stats.R')
source('R Files/OHL_SH_Stats.R')
source('R Files/OHL_Schedule.R')
source('R Files/OHL_Teams.R')


# MySQL Information
db_host <- '127.0.0.1' # or 'localhost'
db_user <- 'root'
db_password <- 'noahnoah'
db_name <- 'sys'

# MySQL Connection
con <- dbConnect(RMariaDB:MariaDB(),
        dbname = db_name,
        username = db_user,
        password = db_password,
        host = db_host)

# Check Connection
if (dbIsValid(con)){
    print("Connection is up and running.")
    } else {
    print("Connection has failed.")
    }

# insert specific code for each upload.
#
#
#
#
#


dbDisconnect(con)






