# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Dummy::Application.initialize!

%w[employee total].each do |report|
  require File.expand_path("../../../support/reports/#{report}_report", __FILE__)
end
