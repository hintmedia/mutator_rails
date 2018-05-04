# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added

### Changed

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

