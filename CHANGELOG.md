# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added

### Changed

### Removed

## [0.1.17] - 2020-07-31

_NB: Some of the changes below were released in versions not reflected in this Changelog. This entry brings us up to date._

### Added

- Add -j1 fallback and failure tracking to statistics.
  [I50](https://github.com/dinj-oss/mutator_rails/issues/50) [PR49](https://github.com/dinj-oss/mutator_rails/pull/49)

- Add check for pending migrations that fail jobs.
  [I57](https://github.com/dinj-oss/mutator_rails/issues/57) [PR60](https://github.com/dinj-oss/mutator_rails/pull/60)


### Changed

- Sort the -j1 and failure lists to keep them in order for GIT.
  [I56](https://github.com/dinj-oss/mutator_rails/issues/56) [PR61](https://github.com/dinj-oss/mutator_rails/pull/61)


- Upgrade for rails security issues.
  [I58](https://github.com/dinj-oss/mutator_rails/issues/58) [PR59](https://github.com/dinj-oss/mutator_rails/pull/59)


### Removed

## [0.1.11] - 2018-05-04

### Added

### Changed

- Updated `rails-html-sanitzer` gem to address security vulnerability.
  [I46](https://github.com/dinj-oss/mutator_rails/issues/46) [PR45](https://github.com/dinj-oss/mutator_rails/pull/45)

### Removed

## [0.1.10] - 2018-04-13

### Added

### Changed

- Updated Loofah and Nokogiri gems to address a security vulnerability.
  [I45](https://github.com/dinj-oss/mutator_rails/issues/45)

### Removed

## [0.1.9] - 2018-01-26

### Added

- Added this changelog.
  [I41](https://github.com/dinj-oss/mutator_rails/issues/41) [PR40](https://github.com/dinj-oss/mutator_rails/pull/40)

- Updated Nokogiri gem to 1.8.1 to address a security vulnerability.
  [I38](https://github.com/dinj-oss/mutator_rails/issues/38) [PR42](https://github.com/dinj-oss/mutator_rails/pull/42)


### Changed

- Altered the order of the tasks run under `mutator:all` so that the `cleanup`
  phase occurs before the `analyze` phase.
  [I39](https://github.com/dinj-oss/mutator_rails/issues/39) [PR44](https://github.com/dinj-oss/mutator_rails/pull/44)

### Removed

