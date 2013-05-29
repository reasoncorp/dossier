require 'spec_helper'

describe "namespaced report" do
  
  describe "rendering html" do

    it "displays the correct html" do
      visit '/reports/cats/are/super_fun'
      expect(page).to have_content('Super Fun Report')
    end

  end

end

