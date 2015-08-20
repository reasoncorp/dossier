require 'spec_helper'

describe "routing to dossier" do
  it "routes /dossier/reports/:report to dossier/reports#show" do
    expect(:get => '/reports/employee').to route_to(
      :controller => 'dossier/reports',
      :action     => 'show',
      :report     => 'employee'
    )
  end
end
