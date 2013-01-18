require 'spec_helper'

describe EmployeeWithCustomClientReport do

  describe "rendering HTML" do

    it "builds a report using the specified client's database" do
      get "reports/employee_with_custom_client"
      expect(response.body).to eq(File.read('spec/fixtures/reports/employee_with_custom_client.html'))
    end

  end
end
