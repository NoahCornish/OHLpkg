\name{Package Help}
\alias{Package Help}
\title{OHLpkg}
\usage{
get_Stats()
get_RawStats()
get_GoalieStats()
get_EVStats()
get_SHStats()
get_DYStats()
get_RKStats()
get_Schedule()
}
\description{
get_Stats()
- creates a dataframe with the requested player stats.
- filters out players who haven't played at least 10 games.

get_RawStats()
- creates a dataframe with the requested player stats.

get_GoalieStats()
- creates a dataframe with the requested goalie stats.
- filters out goalies who haven't played at least 10 games.

get_EVStats()
- creates a dataframe with the 2024-2025 EV Strength Player stats.
- filters out players who haven't played at least 10 games.

get_SHStats()
- creates a dataframe with the 2024-2025 Short-Handed Player stats.
- filters out players who haven't played at least 10 games.

get_DYStats()
- creates a dataframe with the 2024-2025 Draft Eligible Skaters stats.
- filters out players who haven't played at least 10 games.

get_RKStats()
- creates a dataframe with the requested rookie Skaters stats
- filters out players who haven't played at least 10 games.

get_Teams()
- creates a dataframe with the 2024-2025 Teams.

get_Schedule()
- creates a dataframe with the 2024-2025 OHL regular season schedule.

}
\arguments{
get_RawStats()
get_Stats()
get_GoalieStats()
get_RKStats()
These functions above have arguments.

Ex/
Reg <- get_RawStats(season_name = "2024 Season")
Plof <- get_RawStats(season_name = "2024 Playoffs")

Regular season and playoff data is available from 1998->2025.
Pre-Season data is temporarily available for the 2024 and 2025 season.
}
\examples{
q <- get_Stats()
w <- get_RawStats()
e <- get_GoalieStats()
r <- get_EVStats()
t <- get_SHStats()
y <- get_DYStats()
u <- get_RKStats()
i <- get_Teams()
o <- get_Schedule()
}
