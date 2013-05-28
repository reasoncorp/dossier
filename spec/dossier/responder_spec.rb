require 'spec_helper'

describe Dossier::Responder do

  def stub_out_report_results(report)
    report.tap { |r|
      r.stub(:results).and_return(results)
      r.stub(:raw_results).and_return(results)
    }
  end

  let(:results)    { mock(arrays: [[]], hashes: [{}]) }
  let(:report)     { EmployeeReport.new }
  let(:reports)    { [stub_out_report_results(report)] }
  let(:controller) { 
    ActionController::Base.new.tap { |controller| controller.stub(:headers).and_return({}) }
  }
  let(:responder)  { described_class.new(controller, reports, {}) }

  describe "to_html" do
    let(:options) { {template: "dossier/reports/#{template}", locals: {report: report}} }

    describe "with custom view" do
      let(:report)   { EmployeeWithCustomViewReport.new }
      let(:template) { report.class.report_name }

      it "renders the custom view" do
        controller.should_receive(:render).with(options)
      end
    end

    describe "without custom view" do
      let(:template) { 'show' }

      it "renders show" do
        controller.should_receive(:render).with(options.merge(template: 'dossier/reports/employee')).and_call_original
        controller.should_receive(:render).with(options)
      end
    end

    after(:each) { responder.to_html }
  end

  describe "to_json" do
    it "renders the report as json" do
      controller.should_receive(:render).with(json: results.hashes)
      responder.to_json
    end
  end

  describe "to_csv" do
    it "sets the content disposition" do
      responder.should_receive(:set_content_disposition!)
      responder.to_csv
    end

    it "sets the response body to a new csv streamer instance" do
      responder.to_csv
      expect(responder.controller.response_body).to be_a(Dossier::StreamCSV)
    end
  end

  describe "to_xls" do
    it "sets the content disposition" do
      responder.should_receive(:set_content_disposition!)
      responder.to_xls
    end

    it "sets the response body to a new xls instance" do
      responder.to_xls
      expect(responder.controller.response_body).to be_a(Dossier::Xls)
    end
  end

end

