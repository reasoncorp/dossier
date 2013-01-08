# Dossier

Dossier is a Rails engine for reporting. Reports are creating using SQL and can be easily rendered in various formats, like JSON, CSV, etc.

## Usage (Extremely Incomplete)

In your app, create report classes under `app/reports`, `Report` as the end of the class name. For example:


```ruby
# app/reports/fancy_ketchup_report.rb
class FancyKetchupReport < Dossier::Report
  select '* FROM ketchups WHERE fancy = true'
end
```

Dossier will add a route to your app so that `reports/fancy_ketchup` will instantiate and run a `FancyKetchupReport`. It will respond with whatever format was requested; for example `reports/fancy_ketchup.csv` will render the results as CSV.


## Misc

This project rocks and uses MIT-LICENSE.
