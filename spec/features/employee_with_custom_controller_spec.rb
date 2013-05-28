require 'spec_helper'

describe "EmployeeReport with custom controller" do

  describe "rendering HTML" do

    it "builds a report using the specified client's database" do
      visit "/employee_report_custom_controller"
      expect(page).to have_selector("table thead tr", count: 1)
      expect(page).to have_selector("table tbody tr", count: 3)
    end

  end
end
