require 'spec_helper'

describe Dossier::Responder do

  def mock_out_report_results(report)
    report.tap { |r|
      allow(r).to receive(:results).and_return(results)
      allow(r).to receive(:raw_results).and_return(results)
    }
  end

  let(:results)    { double(arrays: [%w[hi], %w[there]], hashes: [{hi: 'there'}]) }
  let(:report)     { EmployeeReport.new }
  let(:reports)    { [mock_out_report_results(report)] }

  let(:controller) { 
    ActionController::Base.new.tap { |controller| 
      controller.response = ActionDispatch::TestResponse.new(200, {}, [''])
    }
  }
  let(:responder)  { described_class.new(controller, reports, {}) }

  describe "to_html" do
    it "calls render on the report" do
      expect(report).to receive(:render)
      responder.to_html
    end
  end

  describe "to_json" do
    it "renders the report as json" do
      expect(controller).to receive(:render).with(json: results.hashes)
      responder.to_json
    end
  end

  describe "to_csv" do
    it "sets the content disposition" do
      expect(responder).to receive(:set_content_disposition!)
      responder.to_csv
    end

    it "sets the response body to a new csv streamer instance" do
      responder.to_csv
      expect(responder.controller.response_body).to be_a(Dossier::StreamCSV)
    end

    it "formats the headers that are passed to Dossier::StreamCSV" do
      expect(report).to receive(:format_header).with('hi')
      responder.to_csv
    end
  end

  describe "to_xls" do
    it "sets the content disposition" do
      expect(responder).to receive(:set_content_disposition!)
      responder.to_xls
    end

    it "sets the response body to a new xls instance" do
      responder.to_xls
      expect(responder.controller.response_body).to be_a(Dossier::Xls)
    end

    it "formats the headers that are passed to Dossier::Xls" do
      expect(report).to receive(:format_header).with('hi')
      responder.to_csv
    end
  end

end

