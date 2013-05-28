require 'spec_helper'

describe Dossier::MultiReport do

  let(:options)         { {'foo' => 'bar'} }
  let(:combined_report) { CombinationReport }
  let(:report)          { combined_report.new(options) }

  it 'knows its sub reports' do
    expect(combined_report.reports).to eq([EmployeeReport, EmployeeWithCustomViewReport])
  end

  it "passes options to the sub reports" do
    combined_report.reports.each do |report|
      report.should_receive(:new).with(options).and_call_original
    end

    report.reports
  end

  it "sets the multi property on its child reports" do
    expect(report.reports.first.parent).to eq(report)
  end

  it "never has a parent" do
    expect(report.parent).to be_nil
  end
end
