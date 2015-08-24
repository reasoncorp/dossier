# Changelog

Dossier does its best to use [semantic versioning](http://semver.org).

## Unreleased

## v2.13.0
- Heroku `DATABASE_URL` support
- CSS classes on Dossier views
- `Dossier::Naming` renamed to `Dossier::Model`
- Reports have a `display_column?(name)` method that can be overriden to
    determine if a column should be displayed.
- Rails v4.2.X support
- headers will now be formatted without calling `format_header` in the view, that will be called when accessing them (I'm not sure if this may cause backwards incompatible changes with custom views.  I don't *think* so.
- introduced `format_column(column, value)` as a default formatter that can be implemented as a fall back if a specific format method does not exist
- Add license to gemspec, thanks to notice from [Benjamin Fleischer](https://github.com/bf4) - see [his blog post](http://www.benjaminfleischer.com/2013/07/12/make-the-world-a-better-place-put-a-license-in-your-gemspec/)
- Output files now have a sortable date/time stamp by default. Eg, "foo-report_2014-10-02_09-12-24-EDT.csv". This can still be customized by defining a report class's `filename` method.
- Add CSS classes to report `<table>` elements to facilitate styling.

## v2.8.0
- Support namespaces for report names (`cats/are/super_fun` => `Cats::Are::SuperRunReport`
- Moved controller response formats into responder class
- Added renderer that contains logic for custom views, this has a pluggable engine depending on if the request is through the controller or through direct object access.  If it is through the controller, the controller will be used as the rendering engine, otherwise a basic controller that only renders will be used.
- Filename is configurable by overriding `self.filename` in any given report class
- Options have been extracted into a partial so the entire view doesn't need to be overridden
- Reports will work natively with `form_for` with no additional options (except `method: :get`)
- added in `number_to_dollars` and `commafy_number` which are American only versions of `number_to_currency` and `number_with_precision` because they are suuuuuuuper slow on large datasets. (17k records profiled at 39 seconds vs 3 with the cheap ones)
- added ability to use the report's formatter in view context for a custom view
- allows setting template at class or instance level. Class.template = 'x' or def template; 'x'; end

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
