# Changelog

Dossier does its best to use [semantic versioning](http://semver.org).

## Unreleased

- Made `#report_class` a public method on `Dossier::ReportsController` for easier integration with authorization gems
- Moved "Download CSV" link to top of default report view

## v2.3.0

Removed `view` method from report.  Moved all logic for converting to and from report names from classes into Dossier module.  Refactored spec support files.  Fixed issue when rendering dossier template outside of `Dossier::ReportsController`.

## v2.2.0

Support for XLS output, added by [michelboaventura](https://github.com/michelboaventura)

## v2.1.1

Fixed bug: in production, CSV rendering should not contain a backtrace if there's an error.

## v2.1.0

Formatter methods will now be passed a hash of the row values if they accept a second argument. This allows formatting certain rows specially.

## v2.0.1

Switched away from `classify` in determining report name to avoid singularization.

## v2.0.0

First public release (previously internal)
