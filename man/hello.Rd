\name{Hello}
\alias{Hello}
\title{OHLpkg!}
\usage{
get_Stats()
get_EVStats()
get_DYStats()
}
\description{
get_Stats() creates a dataframe with the 2023-2024 Player Statistics.
get_Stats() has filtered out players who haven't played at least 10 games.

get_EVStats() creates a dataframe with the 2023-2024 EV Strength Player Stats.
get_EVStats() has filtered out players who haven't played at least 10 games.

get_DYStats() creates a dataframe with the 2023-2024 Draft Eligible Skaters Stats.
get_DYStats() has filtered out players who haven't played at least 10 games.

}
\examples{
x <- get_Stats()
y <- get_EVStats()
z <- get_DYStats()
}
