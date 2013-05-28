require 'spec_helper'

describe EmployeeWithCustomClientReport do

  describe "rendering HTML" do

    it "builds a report using the specified client's database" do
      visit '/reports/employee_with_custom_client'
      expect(page).to have_selector('table tbody tr', count: 3)
      expect(page).to have_selector('td', text: 'ELISE ELDERBERRY')
    end

  end
end
