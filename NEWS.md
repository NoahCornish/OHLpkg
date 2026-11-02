
# OHLpkg 2.7.0

OHLpkg 2.7.0 introduces new skater statistics functions, expands access to raw player data, adds player draft information, improves internal package organization, and significantly strengthens automated test coverage.

This release expands OHLpkg's analytical capabilities while maintaining compatibility with existing functions.

## New Features

### Power-Play Statistics — `get_PPStats()`

- Added `get_PPStats()` for retrieving OHL power-play statistics.
- Includes power-play goals (`PPG`), assists (`PPA`), points (`PPP`), points per game (`PPP/G`), and power-play point percentage (`PPP%`).
- Supports team and minimum-games filtering.
- Provides consistent sorting and output formatting alongside existing special-teams functions.

### Penalty-Minute Statistics — `get_PIMStats()`

- Added `get_PIMStats()` for retrieving OHL penalty-minute statistics.
- Includes total penalty minutes (`PIM`) and penalty minutes per game (`PIM/G`).
- Supports single-team, multiple-team, and minimum-games filtering.
- Provides a dedicated interface for analyzing player penalty statistics.

### Complete Raw Player Statistics — `get_AllRawStats()`

- Added `get_AllRawStats()` to retrieve all available player-statistics columns returned by the OHL HockeyTech API.
- Preserves original API field names without removing statistical columns.
- Includes additional statistical categories such as faceoffs, shooting metrics, and other available player information.
- Supports season selection and optional team filtering.
- Provides greater flexibility for users conducting custom statistical analyses.

Unlike `get_RawStats()`, this function retains the complete set of statistical fields supplied by the source feed.

### Player Draft Information — `get_DraftData()`

- Added `get_DraftData()` for retrieving player draft information from official OHL player profiles.
- Supports individual player searches using `PlayerID`.
- Supports season-wide and team-specific retrieval using `get_AllRawStats()` as its player data source.
- Retrieves separate draft information for:
  - OHL Priority Selection
  - OHL U18 Priority Selection
  - CHL Import Draft
  - NHL Entry Draft
- Includes available draft year, round, overall selection, and drafting team information.
- Adds a `FreeAgent` indicator to distinguish players without an identified OHL, U18, or Import Draft selection.
- Includes acquisition classification, player profile URLs, and retrieval status information.
- Supports optional CSV export for further analysis.

The function introduces `rvest` as a package dependency for retrieving official OHL player-profile information.

### Expanded Player Identification — `get_RawStats()`

- Added `PlayerID` and `PhotoURL` columns to `get_RawStats()`.
- `PlayerID` exposes the HockeyTech player identifier.
- `PhotoURL` provides a direct OHL player headshot URL generated from each player's ID.
- Improves compatibility between player statistics and external player-profile data.

## Improvements

### Package Organization

- Standardized source file names so exported functions use matching `.R` filenames.
- Renamed legacy `OHL_*` source files to improve package organization and navigation.
- Improved consistency between public functions, source files, documentation, and automated tests.
- Updated function documentation and usage examples.
- Introduced `NEWS.md` as the permanent changelog for future OHLpkg releases.

### Statistical Consistency

- Improved consistency across `get_EVStats()`, `get_PPStats()`, and `get_SHStats()`.
- Standardized special-teams sorting behaviour.
- Updated `get_EVStats()` to use even-strength goals as a secondary sorting criterion when players are tied in even-strength points.
- Improved consistency in statistical output formatting and filtering.
- Expanded access to player information without changing the intended purpose of existing statistical functions.

## Testing

Automated test coverage has been significantly expanded across the OHLpkg public API.

Dedicated tests now cover:

- `get_Stats()`
- `get_RawStats()`
- `get_AllRawStats()`
- `get_DraftData()`
- `get_GoalieStats()`
- `get_EVStats()`
- `get_PPStats()`
- `get_SHStats()`
- `get_PIMStats()`
- `get_DYStats()`
- `get_RKStats()`
- `get_GameEvents()`
- `get_PlayerInfo()`
- `get_Schedule()`
- `get_Seasons()`
- `get_Teams()`

Tests check important package behaviour, including:

- Output structure and expected column names
- Team and multiple-team filtering
- Minimum-games filtering
- Power-play and special-teams calculations
- Penalty-minutes-per-game calculations
- Rookie and draft-eligibility filtering
- Player ID and headshot URL generation
- Raw API column preservation
- Draft function argument validation
- Season mapping and validation
- Goalie and player data formatting
- Game ID validation
- Sorting behaviour
- Invalid inputs
- API-derived outputs

The OHLpkg 2.7.0 automated test suite contains **156 passing expectations, with 0 failures, 0 warnings, and 0 skipped tests**.

## Dependencies

- Added `rvest` to package imports to support retrieval of official OHL player-profile information.
- Continued using `jsonlite` for HockeyTech API data retrieval and JSON processing.

## For Users and Developers

For newer R users, OHLpkg is easier to explore through consistent function naming, predictable outputs, and expanded documentation.

For hockey analysts, the release introduces access to complete raw statistical data, additional special-teams metrics, and player draft information.

For experienced R developers, version 2.7.0 provides stronger regression protection, more consistent function behaviour, richer player datasets, and improved internal organization.

OHLpkg 2.7.0 establishes a stronger foundation for future package development and more advanced Ontario Hockey League statistical analysis.
