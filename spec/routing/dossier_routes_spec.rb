require 'spec_helper'

describe "routing to dossier" do
  it "routes /dossier/reports/:report to dossier/reports#show" do
    pending "figure out why this doesn't work in the test"
    {:get => '/dossier/reports/employee'}.should route_to(
      :namespace  => 'dossier',
      :controller => 'reports',
      :action     => 'show',
      :report     => 'employee'
    )
  end
end
