# **Functions to Access Ontario Hockey League Data**

------------------------------------------------------------------------

The ***OHLpkg*** is presently at **Version 1.4.0**, which is the fourth minor release in its first major version.

**Version 1.4.0** has the following functions: **`get_Stats, get_EVStats, get_SHStats, get_DYStats, get_RKStats, get_Teams`**

------------------------------------------------------------------------

#### ***Download this package by entering these lines of code.***

This is the third minor update to the first major version. **Version 1.3.0** enables users who use the **OHLpkg R Package** access to OHL Data. At this time, *LeagueStats*, *EVStats*, *DYStats*, *RKStats*, and *Teams* is available for use. Download this package by entering these lines of code.

`devtools::install_github('NoahCornish/OHLpkg')`

`library(OHLpkg)`

This will install the package directly from this repository. Use the Help information for packages at this time. The DESCRIPTION file will provide instructions on how to use this package.

------------------------------------------------------------------------

#### **Here's a breakdown of each function:**

1.  **`get_Stats`**: This function fetches a JSON dataset from a specified URL, processes it, and returns a dataframe (**`LeagueStats`**) with specific statistics. It removes some irrelevant columns, converts certain columns to numeric types, and performs date processing. The final dataframe includes player names, rookie status, jersey number, birthdate, height, weight, position, team name, and various gameplay statistics like games played, goals, assists, points, etc.

2.  **`get_EVStats`**: Similar to **`get_Stats`**, but it focuses on "Even Strength" stats. It filters and calculates specific stats like Even Strength Goals (EVG), Assists (EVA), Points (EVPTS), and calculates additional metrics like EVPTS per game and percentage of total points that are even strength.

3.  **`get_DYStats`**: This function processes data for players who are eligible for the NHL draft this year (DY). It filters players based on their birthdate to include only those eligible for a particular draft year and selects various statistics relevant to scouting and draft considerations.

4.  **`get_RKStats`**: Focuses on statistics for rookie players. It filters the dataset for rookies and selects relevant statistics for these players, such as goals, assists, points, and game-winning goals.

5.  **`get_Teams`**: This function seems to extract distinct team names from the dataset, possibly for creating team-specific visualizations or analyses.

------------------------------------------------------------------------

#### **Latest Version Update**

***Version 1.4.0*** has introduced Short-Handed Stats for all skaters who have played more than nine (9) games.

------------------------------------------------------------------------

#### **Current Package Functions**

| Function        | Information                                                                |
|------------------|------------------------------------------------------|
| **get_Stats**   | Returns all skaters statistics                                             |
| **get_EVStats** | Returns skaters (GP\>9) even-strength statistics                           |
| **get_SHStats** | Returns skaters (GP\>9) short-handed statistics                            |
| **get_DYStats** | Returns skaters (GP\>9) statistics who are NHL draft year (DY-0) eligible  |
| **get_RKStats** | Returns skaters (GP\>9) statistics who are playing in their first OHL year |
| **get_Teams**   | Returns a data table consisting of all 20 OHL teams                        |

------------------------------------------------------------------------
