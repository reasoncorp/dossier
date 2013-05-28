require 'spec_helper'

describe Dossier::Renderer do

  let(:report)   { EmployeeReport.new }
  let(:renderer) { described_class.new(report) }
  let(:engine)   { renderer.engine }

  describe "rendering" do
    let(:options) { {template: "dossier/reports/#{template}", locals: {report: report}} }

    describe "with custom view" do
      let(:report)   { EmployeeWithCustomViewReport.new }
      let(:template) { report.report_name }

      it "renders the custom view" do
        engine.should_receive(:render).with(options)
      end
    end

    describe "without custom view" do
      let(:template) { 'show' }

      it "renders show" do
        engine.should_receive(:render).with(options.merge(template: 'dossier/reports/employee')).and_call_original
        engine.should_receive(:render).with(options)
      end
    end

    after(:each) { renderer.render }
  end

  describe "engine" do
    describe "view_context" do
      it "mixes in the dossier/application_helper to that view context" do
        expect(engine.view_context.class.ancestors).to include(Dossier::ApplicationHelper)
      end
    end

    describe "view path" do
      it "has the same view paths the application would have" do
        extractor = ->(vp) { vp.paths }
        expect(extractor.call engine.view_paths).to eq(extractor.call ActionController::Base.view_paths)
      end
    end

    describe "layouts" do
      it "uses a layout" do
        expect(report.render).to match('<html>')
      end

      it "makes the report available to the layout" do
        expect(report.render).to match('<title>Employee Report</title>')
      end
    end
  end
end
