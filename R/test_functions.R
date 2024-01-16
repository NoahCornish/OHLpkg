
# This is the test .R file you may use to access the data.

devtools::install_github('NoahCornish/OHLpkg')
library(OHLpkg)

Stats <- get_Stats()
GoalieStats <- get_GoalieStats()
EVStats <- get_EVStats()
SHStats <- get_SHStats()
DraftYearStats <- get_DYStats()
RookieStats <- get_RKStats()
OHLTeams <- get_Teams()
OHLSchedule <- get_Schedule()
