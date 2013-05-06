require 'spec_helper'

describe 'dossier:views' do
  context "with no arguments or options" do

    before :each do
      FileUtils.rm_rf("spec/dummy/app/views/dossier/reports/show.html.haml")
    end

    it "should generate a view file" do
      FileTest.exists?(Rails.root.join("app" "views" "dossier" "show.html.haml"))
    end
  end

  with_args "account_tracker" do

    before :each do
      FileUtils.rm_rf("spec/dummy/app/views/dossier/reports/account_tracker.html.haml")
    end

    it "should generate a edit_account form" do
      FileTest.exists?(Rails.root.join("app" "views" "dossier" "account_tracker.html.haml"))
    end 
  end
end
