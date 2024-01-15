\name{Package Help}
\alias{Package Help}
\title{OHLpkg}
\usage{
get_Stats()
get_EVStats()
get_SHStats()
get_DYStats()
get_RKStats()
get_Schedule()
}
\description{
get_Stats()
- creates a dataframe with the 2023-2024 Player stats.
- filters out players who haven't played at least 10 games.

get_EVStats()
- creates a dataframe with the 2023-2024 EV Strength Player stats.
- filters out players who haven't played at least 10 games.

get_SHStats()
- creates a dataframe with the 2023-2024 Short-Handed Player stats.
- filters out players who haven't played at least 10 games.

get_DYStats()
- creates a dataframe with the 2023-2024 Draft Eligible Skaters stats.
- filters out players who haven't played at least 10 games.

get_RKStats()
- creates a dataframe with the 2023-2024 Rookie Skaters stats
- filters out players who haven't played at least 10 games.

get_Teams()
- creates a dataframe with the 2023-2024 Teams.

get_Schedule()
- creates a dataframe with the 2023-2024 OHL regular season schedule.

}
\examples{
q <- get_Stats()
w <- get_EVStats()
e <- get_DYStats()
r <- get_RKStats()
t <- get_Teams()
y <- get_Schedule()
}
