require 'spec_helper'

describe "employee report" do

  describe "rendering CSV" do

    it "creates a standard CSV report" do
      visit '/reports/employee.csv'
      expect(page.body.downcase).to(
        eq(File.read('spec/fixtures/reports/employee.csv').downcase))
    end

  end

  describe "rendering XLS" do

    it "creates a standard XLS report" do
      visit '/reports/employee.xls'
      expect(page.body.downcase).to(
        eq(File.read('spec/fixtures/reports/employee.xls').downcase))
    end

  end

end
