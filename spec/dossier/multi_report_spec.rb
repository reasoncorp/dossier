require 'spec_helper'

describe Dossier::MultiReport do

  let(:combined_report) {CombinationReport}    

  it 'knows its sub reports' do
    expect(combined_report.reports).to eq([EmployeeReport, EmployeeWithCustomViewReport])
  end

end
