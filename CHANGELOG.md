# Changelog

## Unreleased

### Changed
- ~~Bump `alpine` image to 3.16.0 (#92)~~

## v0.5.1 - 2022-05-07

## Added
- Added `FETCH_LIMIT`/`--fetch-limit` to configure the default time to fetch for plotting (requested in #53)

### Changed
- Bumped Flask version to 2.1.2 (#87)
- Numerous Dependabot updates to workflow action versions

## v0.5.0 - 2022-05-07

### Added
- Retry measurements when the server list is temporarily unavailable (fixed #72)
- Started this `CHANGELOG.md`

### Changed
- Use line plot with steps for Ping as well (fixed #62)
- Remove leading slash from ressources to allow subdirectories behind reverse-proxies (fixed #76)
- Lots of Dependabot updates to workflow actions and pip packages

## v0.4.0 - 2021-09-09

Last release before starting a changelog. Please just check the commit log for
anything before this release.
