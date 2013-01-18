require 'spec_helper'

describe EmployeeWithCustomClientReport do

  describe "rendering HTML" do

    it "is awesome" do
      get "reports/employee_with_custom_client"
      expect(response.body).to eq(File.read('spec/fixtures/employee_with_custom_client.html'))
    end

  end
end
