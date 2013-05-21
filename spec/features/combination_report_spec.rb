require 'spec_helper'

describe "combination report" do
  
  describe "rendering html" do

    context "when no custom view exists" do
      
      it "displays the correct html" do
        visit '/multi/reports/combination'
        expect(page).to have_content('Employee Report')
        expect(page).to have_content('Employee With Custom View Report')
      end

    end

  end

end

