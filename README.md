# OHLpkg: R Package for Ontario Hockey League Data

------------------------------------------------------------------------

![](https://img.shields.io/badge/Version%201.4.0-8A2BE2)

![](https://img.shields.io/badge/OHLpkg-E22B2B)

![](https://img.shields.io/github/issues/NoahCornish/OHLpkg)

------------------------------------------------------------------------

#### ***Download this package by entering these lines of code.***

This is the third minor update to the first major version. **Version 1.4.0** enables users who use the **OHLpkg R Package** access to OHL Data. At this time, *LeagueStats*, *EVStats*, *DYStats*, *RKStats*, and *Teams* is available for use. Download this package by entering these lines of code.

`devtools::install_github('NoahCornish/OHLpkg')`

`library(OHLpkg)`

This will install the package directly from this repository. Use the Help information for packages at this time. The DESCRIPTION file will provide instructions on how to use this package.

------------------------------------------------------------------------

#### **Here's a breakdown of each function:**

1.  **`get_Stats`**: This function fetches a JSON dataset from a specified URL, processes it, and returns a dataframe (**`LeagueStats`**) with specific statistics. It removes some irrelevant columns, converts certain columns to numeric types, and performs date processing. The final dataframe includes player names, rookie status, jersey number, birthdate, height, weight, position, team name, and various gameplay statistics like games played, goals, assists, points, etc.

2.  **`get_SHStats`** : This function produces "Short Handed" stats. It filters and calculates specific stats like Short Handed Goals (SHG), Assists (SHA), Points (SHPTS), and calculates additional metrics like SHPTS per game and percentage of total points that are Short Handed.

3.  **`get_EVStats`**: Similar to **`get_Stats`**, but it focuses on "Even Strength" stats. It filters and calculates specific stats like Even Strength Goals (EVG), Assists (EVA), Points (EVPTS), and calculates additional metrics like EVPTS per game and percentage of total points that are even strength.

4.  **`get_DYStats`**: This function processes data for players who are eligible for the NHL draft this year (DY). It filters players based on their birthdate to include only those eligible for a particular draft year and selects various statistics relevant to scouting and draft considerations.

5.  **`get_RKStats`**: Focuses on statistics for rookie players. It filters the dataset for rookies and selects relevant statistics for these players, such as goals, assists, points, and game-winning goals.

6.  **`get_Teams`**: This function seems to extract distinct team names from the dataset, possibly for creating team-specific visualizations or analyses.

------------------------------------------------------------------------

#### **Latest Version Update**

***Version 1.4.0*** has introduced Short-Handed Stats for all skaters who have played more than nine (9) games.

------------------------------------------------------------------------

#### **Current Package Functions**

| Function        | Information                                                                |
|---------------------------|---------------------------------------------|
| **get_Stats**   | Returns all skaters statistics                                             |
| **get_EVStats** | Returns skaters (GP\>9) even-strength statistics                           |
| **get_SHStats** | Returns skaters (GP\>9) short-handed statistics                            |
| **get_DYStats** | Returns skaters (GP\>9) statistics who are NHL draft year (DY-0) eligible  |
| **get_RKStats** | Returns skaters (GP\>9) statistics who are playing in their first OHL year |
| **get_Teams**   | Returns a data table consisting of all 20 OHL teams                        |

------------------------------------------------------------------------
