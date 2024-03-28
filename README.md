# OHLpkg: R Package for Ontario Hockey League Data

------------------------------------------------------------------------

![](https://img.shields.io/badge/OHLpkg-v2.1.0-teal){width="144" height="29"}

![](https://img.shields.io/github/commit-activity/t/NoahCornish/OHLpkg/main){width="144"}

![](https://img.shields.io/github/issues/NoahCornish/OHLpkg){width="144"}

![](https://img.shields.io/github/downloads/NoahCornish/OHLpkg/total){width="142" height="28"}

![](https://img.shields.io/github/repo-size/NoahCornish/OHLpkg){width="142" height="26"}

![](https://img.shields.io/github/license/NoahCornish/OHLpkg){width="143"}

![](https://img.shields.io/badge/Package-Operational-brightgreen.svg){width="147"}

Created by: Noah Cornish

![](OHLpkg_logo.png){width="112"}

------------------------------------------------------------------------

#### **Download this Package**

**`devtools::install_github('NoahCornish/OHLpkg')`**

**`library(OHLpkg)`**

------------------------------------------------------------------------

#### **Latest Version Update**

**Version 2.1.0** has added more seasons for the package argument.

#### **Package Functions**

| Function              | Information                                                                |
|------------------|------------------------------------------------------|
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

**Package Arguments**

| Function              | Argument    |
|-----------------------|-------------|
| **get_RawStats()**    | season_name |
| **get_Stats()**       | season_name |
| **get_GoalieStats()** | season_name |
| **get_RKStats()**     | season_name |

Example:

*`x <- get_RawStats(season_name = "2024 Season")`*

Seasons:

Regular season and playoff data is available from 2016-\>2024.

Additional regular season and playoff data will be provided incrementally.

------------------------------------------------------------------------

Created by:\
Noah Cornish

[![](https://img.shields.io/twitter/follow/NoahCornish)](https://twitter.com/NoahCornish)
