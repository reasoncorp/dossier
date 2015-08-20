require 'spec_helper'

require 'generators/dossier/views/views_generator'

describe Dossier::ViewsGenerator, type: :generator  do
  context "with no arguments or options" do

    before :each do
      FileUtils.rm_rf("spec/dummy/app/views/dossier/reports/show.html.haml")
      run_generator
    end

    it "should generate a view file" do
      FileTest.exists?(Rails.root.join("app" "views" "dossier" "show.html.haml"))
    end
  end

  context "with_args: account_tracker" do

    before :each do
      FileUtils.rm_rf("spec/dummy/app/views/dossier/reports/account_tracker.html.haml")
      run_generator %w[account_tracker]
    end

    it "should generate a edit_account form" do
      FileTest.exists?(Rails.root.join("app" "views" "dossier" "account_tracker.html.haml"))
    end 
  end
end
