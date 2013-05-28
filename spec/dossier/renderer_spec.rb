require 'spec_helper'

describe Dossier::Renderer do

  let(:report)   { EmployeeReport.new }
  let(:renderer) { described_class.new(report) }

  describe "rendering" do
    let(:options) { {template: "dossier/reports/#{template}", locals: {report: report}} }

    describe "with custom view" do
      let(:report)   { EmployeeWithCustomViewReport.new }
      let(:template) { report.class.report_name }

      it "renders the custom view" do
        renderer.should_receive(:render_to_string).with(options)
      end
    end

    describe "without custom view" do
      let(:template) { 'show' }

      it "renders show" do
        renderer.should_receive(:render_to_string).with(options.merge(template: 'dossier/reports/employee')).and_call_original
        renderer.should_receive(:render_to_string).with(options)
      end
    end

    after(:each) { renderer.render }
  end

  describe "view_context" do
    it "will lazy load the view context" do
      renderer.view_context = mock('view_context')
      renderer.class.view_context_class.should_not_receive(:new)
      renderer.view_context
    end

    it "will create a new view context if necessary" do
      expect(renderer.view_context).to be_a(ActionView::Base)
    end

    it "mixes in the dossier/application_helper to that view context" do
      expect(renderer.view_context.ancestors).to include(Dossier::ApplicationHelper)
    end
  end

  describe "view path" do
    it "has the same view paths the application would have" do
      expect(renderer.view_paths).to eq(Rails.application.view_paths)
    end
  end
end
