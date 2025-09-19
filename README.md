# OHLpkg: R Package for Ontario Hockey League Data

------------------------------------------------------------------------

![](https://img.shields.io/badge/OHLpkg-v2.4.1-red)

![](https://img.shields.io/github/commit-activity/t/NoahCornish/OHLpkg/main)

![](https://img.shields.io/github/issues/NoahCornish/OHLpkg)

![](https://img.shields.io/github/downloads/NoahCornish/OHLpkg/total)

![](https://img.shields.io/github/repo-size/NoahCornish/OHLpkg)

![](https://img.shields.io/github/license/NoahCornish/OHLpkg)

![](https://img.shields.io/badge/Package-Operational-brightgreen.svg)

Created by: Noah Cornish

![](OHLpkg_logo.png)

------------------------------------------------------------------------

#### **Introduction**

The *OHLpkg* R package provides a comprehensive suite of tools for accessing, analyzing, and visualizing Ontario Hockey League (OHL) data. Designed for hockey analysts, enthusiasts, and data scientists, this package facilitates easy access to OHL statistics, including player stats, team stats, schedules, and more.

The Ontario Hockey League (OHL) is one of the three major junior ice hockey leagues that constitute the Canadian Hockey League (CHL). The OHL is known for producing a significant number of NHL players and is a key developmental league for young hockey talent.

Whether you're conducting a detailed statistical analysis or simply want to explore the latest season data, *OHLpkg* provides all the essential functions you need to work with OHL data in R.

------------------------------------------------------------------------

#### **Download this Package**

To get started with *OHLpkg*, you can install it directly from GitHub using the following commands:

**`devtools::install_github('NoahCornish/OHLpkg')`**

**`library(OHLpkg)`**

------------------------------------------------------------------------

#### **Latest Version Update**

**Version 2.4.1:**

-   Patched a critical error where only `get_Stats()` was available in v2.4.0.
-   All core functions are now properly exported and available after loading the package.

**Version 2.4.0**

-   Added the ability to view and pull 2024-2025 Playoff data.
-   Added the ability to view and pull 2025-2026 Regular Season data.

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
| **get_GameEvents()**  | Returns a data table consisting of single game events.                     |
| **get_PlayerInfo()**  | Returns a data table consisting of player metrics.                         |

------------------------------------------------------------------------

#### **Arguments**

| Function              | Argument    | **Description**                      |
|-----------------------|-------------|--------------------------------------|
| **get_RawStats()**    | season_name | Retrieve skater statistics by season |
| **get_Stats()**       | season_name | Retrieve skater statistics by season |
| **get_GoalieStats()** | season_name | Retrieve goalie statistics by season |
| **get_RKStats()**     | season_name | Retrieve rookie statistics by season |
| **get_GameEvents()**  | game_id     | Retrieve events for a specific game  |
| **get_PlayerInfo()**  | season_name | Retrieve skater metrics by season    |

**Example Usage**

`x <- get_RawStats(season_name = "2026 Season")`

`y <- get_RawStats(season_name = "2025 Playoffs")`

`z <- get_GameEvents(game_id = 12345)`

[OHLpkg Project Information](https://github.com/users/NoahCornish/projects/4?pane=info&statusUpdateId=42574)

------------------------------------------------------------------------

#### **Footnotes**

Regular season and playoff data is available from 1998-\>2026. Regular season and playoff data is only available for the functions (`get_Stats(), get_RawStats(), get_RKStats()`). All other functions will return the current "season" such as the pre-season, regular season, or playoff data.

Pre-Season data is **ONLY** available temporarily for the 2024 and 2025 season. **Once every team has played 10 games in the 2025-2026 season, the 2024 and 2025 pre-season data will be removed.**

This was a temporary addition.

------------------------------------------------------------------------

Created by:\
Noah Cornish

[![](https://img.shields.io/twitter/follow/NoahCornish)](https://twitter.com/NoahCornish)
