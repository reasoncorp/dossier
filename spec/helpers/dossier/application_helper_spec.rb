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

  describe "render_options" do
    describe "if exists" do
      let(:report) { EmployeeWithCustomViewReport.new }
      it "will render the options partial" do
        expect(helper.render_options report).to match('options be here matey!')
      end
    end

    describe "if missing" do
      let(:report) { EmployeeReport.new }
      it "will do nothing" do
        expect(helper.render_options report).to be_nil
      end
    end

    describe "if part of a multi report" do
      let(:multi)  { CombinationReport.new }
      let(:report) { multi.reports.first }
      it "will not render options" do
        expect(helper.render_options report).to be_nil
      end
    end
  end
end
