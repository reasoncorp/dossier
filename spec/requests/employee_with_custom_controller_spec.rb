require 'spec_helper'

describe "EmployeeReport with custom controller" do

  describe "rendering HTML" do

    it "builds a report using the specified client's database" do
      get "/employee_report_custom_controller"
      expect(response.body).to eq(File.read('spec/fixtures/reports/employee.html'))
    end

  end
end
