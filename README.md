# **OHLpkg**

#### **v1.3.1**

![](https://1000logos.net/wp-content/uploads/2018/10/Ontario-Hockey-League-logo.png){width="176" height="100"}

------------------------------------------------------------------------

<<<<<<< HEAD
This is the first bug patch to the second minor update of the first major version. **Version 1.3.1** has made adjustment to the **package_help** file and to the **Description** file. At this time, *LeagueStats*, *EVStats*, *DYStats*, *RKStats*, and *Teams* are available for use.

------------------------------------------------------------------------

***Download this package by entering these lines of code.***
=======
This is the third minor update to the first major version. **Version 1.3.0** enables users who use the **OHLpkg R Package** access to OHL Data. At this time, *LeagueStats*, *EVStats*, *DYStats*, *RKStats*, and *Teams* is available for use. Download this package by entering these lines of code.
>>>>>>> 25d970726244ecd938068c639f35a75f3490f0fb

`devtools::install_github('NoahCornish/OHLpkg')`

`library(OHLpkg)`

This will install the package directly from this repository. Use the Help information for packages at this time. The DESCRIPTION file will provide instructions on how to use this package.

------------------------------------------------------------------------

**Here's a breakdown of each function:**

1.  **`get_Stats`**: This function fetches a JSON dataset from a specified URL, processes it, and returns a dataframe (**`LeagueStats`**) with specific statistics. It removes some irrelevant columns, converts certain columns to numeric types, and performs date processing. The final dataframe includes player names, rookie status, jersey number, birthdate, height, weight, position, team name, and various gameplay statistics like games played, goals, assists, points, etc.

2.  **`get_EVStats`**: Similar to **`get_Stats`**, but it focuses on "Even Strength" stats. It filters and calculates specific stats like Even Strength Goals (EVG), Assists (EVA), Points (EVPTS), and calculates additional metrics like EVPTS per game and percentage of total points that are even strength.

3.  **`get_DYStats`**: This function processes data for players who are eligible for the NHL draft this year (DY). It filters players based on their birthdate to include only those eligible for a particular draft year and selects various statistics relevant to scouting and draft considerations.

4.  **`get_RKStats`**: Focuses on statistics for rookie players. It filters the dataset for rookies and selects relevant statistics for these players, such as goals, assists, points, and game-winning goals.

5.  **`get_Teams`**: This function seems to extract distinct team names from the dataset, possibly for creating team-specific visualizations or analyses.

**More functions will be added in the future**
