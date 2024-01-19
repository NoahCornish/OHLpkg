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









