require 'spec_helper'

describe "routing to dossier" do
  it "routes /dossier/reports/:report to dossier/reports#show" do
    {:get => '/reports/employee'}.should route_to(
      :controller => 'dossier/reports',
      :action     => 'show',
      :report     => 'employee'
    )
  end
end
