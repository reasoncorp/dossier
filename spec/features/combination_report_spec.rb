require 'spec_helper'

describe "combination report" do
  
  it "displays the correct html" do
    visit '/multi/reports/combination'
    expect(page).to have_content('Employee Report')
    expect(page).to have_content('Did you get that memo?')
  end

  it "does not display options for sub reports" do
    visit '/multi/reports/combination'
    expect(page).to_not have_content('options be here matey!')
  end

end

