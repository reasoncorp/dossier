require 'spec_helper'

describe "combination report" do
  let(:path) { dossier_multi_report_path(report: 'combination') }
  
  it "displays the correct html" do
    visit path
    expect(page).to have_content('Employee Report')
    expect(page).to have_content('Did you get that memo?')
  end

  it "displays its options" do
    visit path
    expect(page).to have_content('Some options plz!')
  end

  it "does not display options for sub reports" do
    visit path
    expect(page).to_not have_content('options be here matey!')
  end

  it "raises an UnsupportedFormatError when trying something besides HTML" do
    expect { visit "#{path}.csv" }.to raise_error(Dossier::MultiReport::UnsupportedFormatError, /you tried csv/)
  end
end

