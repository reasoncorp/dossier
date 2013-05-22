require 'spec_helper'
require 'open-uri'

describe Dossier::ApplicationHelper do
  describe "#formatted_dossier_report_path" do
    let(:options) { {divisions: %w[Alpha Omega], salary: 125_000} }
    let(:report)  { EmployeeReport.new(options) }
    let(:path)    { helper.formatted_dossier_report_path('csv', report) }
    let(:uri)     { URI.parse(path) }

    it "generates a path with the given format" do
      expect(uri.path).to match(/\.csv\z/)
    end

    it "generates a path with the given report name" do
      expect(uri.path).to match(/employee/)
    end

    it "generates a path with the given report options" do
      expect(uri.query).to eq({options: options}.to_query)
    end
  end
end
