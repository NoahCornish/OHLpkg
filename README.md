# OHLpkg: R Package for Ontario Hockey League Data

------------------------------------------------------------------------

![](https://img.shields.io/badge/OHLpkg-v2.2.0-teal)

![](https://img.shields.io/github/commit-activity/t/NoahCornish/OHLpkg/main)

![](https://img.shields.io/github/issues/NoahCornish/OHLpkg)

![](https://img.shields.io/github/downloads/NoahCornish/OHLpkg/total)

![](https://img.shields.io/github/repo-size/NoahCornish/OHLpkg)

![](https://img.shields.io/github/license/NoahCornish/OHLpkg)

![](https://img.shields.io/badge/Package-Operational-brightgreen.svg)

Created by: Noah Cornish

![](OHLpkg_logo.png)

------------------------------------------------------------------------

#### **Download this Package**

**`devtools::install_github('NoahCornish/OHLpkg')`**

**`library(OHLpkg)`**

------------------------------------------------------------------------

#### **Latest Version Update**

**Version 2.2.0:**

-   added more regular season data

-   added more playoff data

-   temporarily added selective pre-season data (*see footnotes)*

------------------------------------------------------------------------

#### **Functions**

| Function              | Information                                                                |
|-----------------------|----------------------------------------------------------------------------|
| **get_Stats()**       | Returns skaters statistics (GP \> 9)                                       |
| **get_RawStats()**    | Returns all skaters statistics                                             |
| **get_GoalieStats()** | Returns goalie statistics (GP\>9)                                          |
| **get_EVStats()**     | Returns skaters (GP\>9) even-strength statistics                           |
| **get_SHStats()**     | Returns skaters (GP\>9) short-handed statistics                            |
| **get_DYStats()**     | Returns skaters (GP\>9) statistics who are NHL draft year (DY-0) eligible  |
| **get_RKStats()**     | Returns skaters (GP\>9) statistics who are playing in their first OHL year |
| **get_Teams()**       | Returns a data table consisting of all 20 OHL teams                        |
| **get_Schedule()**    | Returns a data table consisting of the league schedule and results.        |

------------------------------------------------------------------------

#### **Arguments**

| Function              | Argument    |
|-----------------------|-------------|
| **get_RawStats()**    | season_name |
| **get_Stats()**       | season_name |
| **get_GoalieStats()** | season_name |
| **get_RKStats()**     | season_name |

`x <- get_RawStats(season_name = "2025 Season")`

`y <- get_RawStats(season_name = "2025 Playoffs")`

`z <- get_RawStats(season_name = "2025 Pre-Season")`

------------------------------------------------------------------------

#### **Footnotes**

Regular season and playoff data is available from 1998-\>2025. Regular season and playoff data is only available for the functions (`get_Stats(), get_RawStats(), get_RKStats()`). All other functions will return the current "season" such as the pre-season, regular season, or playoff data.

Pre-Season data is **ONLY** available temporarily for the 2024 and 2025 season. **Once the 2025 OHL regular season starts, the pre-season data will be removed.**

------------------------------------------------------------------------

Created by:\
Noah Cornish

[![](https://img.shields.io/twitter/follow/NoahCornish)](https://twitter.com/NoahCornish)
