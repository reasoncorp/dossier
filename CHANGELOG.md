# Changelog

Dossier does its best to use [semantic versioning](http://semver.org).

## Unreleased
- Support namespaces for report names (`cats/are/super_fun` => `Cats::Are::SuperRunReport`
- Moved controller response formats into responder class
- Added renderer that contains logic for custom views, this has a pluggable engine depending on if the request is through the controller or through direct object access.  If it is through the controller, the controller will be used as the rendering engine, otherwise a basic controller that only renders will be used.
- Filename is configurable by overriding `self.filename` in any given report class
- Options have been extracted into a partial so the entire view doesn't need to be overridden

## v2.7.0
- Added `formatted_dossier_report_path` helper method

## v2.6.0
- Support ability to combine reports into a macro report using the Dossier::MultiReport class

## v2.5.0

- Made `#report_class` a public method on `Dossier::ReportsController` for easier integration with authorization gems
- Moved "Download CSV" link to top of default report view
- Formatting the header is now an instance method on the report class called `format_header` (thanks @rubysolo)
- Rails 4 compatibility (thanks @rubysolo)
- Fixed bug when using class names in SQL queries, only lowercase symbols that are a-z will be replaced with the respective method call.
- Added view generator for Rails (thanks @wzcolon)

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
