# Dossier

Dossier is a Rails engine that turns SQL into reports. Reports can be easily rendered in various formats, like HTML, CSV, and JSON.

- If you **hate** SQL, you can use whatever tool you like to generate it; for example, ActiveRecord's `to_sql`.
- If you **love** SQL, you can use every feature feature your database supports.

[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/adamhunter/dossier)

## Setup

Install the Dossier gem and create `config/dossier.yml`. This has the same format as Rails' `database.yml`, and can actually just be a symlink: `ln -s config/{database,dossier}.yml`.

## Routing

Dossier will add a route to your app so that `reports/fancy_ketchup` will instantiate and run a `FancyKetchupReport`. It will respond with whatever format was requested; for example `reports/fancy_ketchup.csv` will render the results as CSV.

## Basic Reports

In your app, create report classes under `app/reports`, with `Report` as the end of the class name. Define a `sql` method that returns the sql string to be sent to the database.

For example:

```ruby
# app/reports/fancy_ketchup_report.rb
class FancyKetchupReport < Dossier::Report
  def sql
    'SELECT * FROM ketchups WHERE fancy = true'
  end

  # Or, if you're using ActiveRecord and hate writing SQL:
  def sql
    Ketchup.where(fancy: true).to_sql
  end

end
```

If you need dynamic values that may be influenced by the user, **[do not interpolate them directly](http://xkcd.com/327/)**. Dossier provides a safer way to add them: any symbols in the query will be replaced by calling methods of the same name in the report. Return values will be **escaped by the database connection**.  Arrays will have all of their contents escaped, joined with a "," and wrapped in parentheses.

```ruby
# app/reports/fancy_ketchup_report.rb
class FancyKetchupReport < Dossier::Report
  def sql
    "SELECT * FROM ketchups WHERE price <= :max_price and brand IN :brands"
    # => "SELECT * FROM ketchups WHERE price <= 7 and brand IN ('Acme', 'Generic', 'SoylentRed')"
  end

  def max_price
    7
  end

  def brands
    %w[Acme Generic SoylentRed]
  end
end
```

## Column Formatting

You can format any values in your results by defining a `format_` method for that column on your report class. For instance, to reverse the names of your employees:

```ruby
class EmployeeReport < Dossier::Report
  # ...
  def format_name(value)
    value.reverse
  end
end
```

Dossier also provides a `formatter` with access to all the standard Rails formatters. So to format all values in the `payment` column as currency, you could do:

```ruby
class MoneyLaunderingReport < Dossier::Report
  #...
  def format_payment(value)
    formatter.number_to_currency(value)
  end
end
```

In addition, the formatter provides Rails' URL helpers for use in your reports. For example, in a report of your least profitable accounts, you might want to add a link to change the salesperson assigned to that account.

```ruby
class LeastProfitableAccountsReport < Dossier::Report
  #...
  def format_account_id(value)
    formatter.link_to value, formatter.url_helpers.edit_accounts_path(value)
  end
end
```

The built-in `ReportsController` uses this formatting when rendering the HTML and JSON representations, but not when rendering the CSV.

If your formatting method takes a second argment, it will be given a hash of the values in the row.

```ruby
class MoneyLaunderingReport < Dossier::Report
  #...
  def format_payment(value, row)
    return "$0.00" if row[:recipient] == 'Jimmy The Squid'
    formatter.number_to_currency(value)
  end
end
```

## Report Options and Footers

You may want to specify parameters for a report: which columns to show, a range of dates, etc. Dossier supports this via URL parameters, anything in `params[:options]` will be passed into your report's `initialize` method and made available via the `options` reader.

You can pass these options by hardcoding them into a link, or you can allow users to customize a report with a form. For example:

```ruby
# app/views/dossier/reports/employee.html.haml

= form_for report, as: :options, url: url_for, html: {method: :get} do |f|
  = f.label "Salary greater than:"
  = f.text_field :salary_greater_than
  = f.label "In Division:"
  = f.select_tag :in_division, divisions_collection
  = f.button "Submit"

= render template: 'dossier/reports/show', locals: {report: report}
```

It's up to you to use these options in generating your SQL query.

However, Dossier does support one URL parameter natively: if you supply a `footer` parameter with an integer value, the last N rows will be accesible via `report.results.footers` instead of `report.results.body`. The built-in `show` view renders those rows inside an HTML footer. This is an easy way to display a totals row or something similar.

## Additional View Customization

To further customize your results view, provide your own `app/views/dossier/reports/show`.

## Callbacks

To produce report results, Dossier builds your query and executes it in separate steps. It uses [ActiveSupport::Callbacks](http://api.rubyonrails.org/classes/ActiveSupport/Callbacks.html) to define callbacks for `build_query` and `execute`. Therefore, you may provide callbacks similar to these:

```ruby
set_callback :build_query, :before, :run_my_stored_procedure
set_callback :execute,     :after do
  mangle_results
end
```

## Using Reports Outside of Dossier::ReportsController

### With Other Controllers

You can use Dossier reports in your own controllers and views. For example, if you wanted to render two reports on a page with other information, you might do this in a controller:

```ruby
class ProjectsController < ApplicationController

  def show
    @project                = Project.find(params[:id])
    @project_status_report  = ProjectStatusReport.new(project: @project)
    @project_revenue_report = ProjectRevenueReport.new(project: @project, grouped: 'monthly')
  end
end
```

```haml
.span6
  = render template: 'dossier/reports/show', locals: {report: @project_status_report.run}
.span6
  = render template: 'dossier/reports/show', locals: {report: @project_revenue_report.run}
```

### Dossier for APIs

```ruby
class API::ProjectsController < Api::ApplicationController

  def snapshot
    render json: ProjectStatusReport.new(project: @project).results.hashes
  end
end
```

## Advanced Usage

To see a report with all the bells and whistles, check out `spec/support/reports/employee_report.rb` or other reports in `spec/support/reports`.

## Compatibility

Dossier currently supports all databases supported by ActiveRecord; it comes with `Dossier::Adapter::ActiveRecord`, which uses ActiveRecord connections for escaping and executing queries. However, as the `Dossier::Adapter` namespace implies, it was written to allow for other connection adapters. See `CONTRIBUTING.md` if you'd like to add one.

## Running the Tests

Note: when you run the tests, Dossier will **make and/or truncate** some tables in the `dossier_test` database.

- Run `bundle`
- `cp spec/dummy/config/database.yml{.example,}` and edit it so that it can connect to the test database.
- `cp spec/fixtures/db/mysql2.yml{.example,}`
- `cp spec/fixtures/db/sqlite3.yml{.example,}`
- `rspec spec`

## Moar Dokumentationz pleaze

- How Dossier uses ORM adapters to connect to databases, currently only AR's are used.
- Examples of connecting to different databases, of the same type or a different one
- Document using hooks and what methods are available in them
- Callbacks, eg:
  - Stored procedures
  - Reformat results
- Linking 
  - To other reports
  - To other formats
- Extending the formatter
- Show how to do "crosstab" reports (preliminary query to determine columns, then build SQL case statements?)
