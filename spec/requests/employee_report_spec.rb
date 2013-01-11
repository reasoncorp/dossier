require 'spec_helper'

describe "employee report" do

  before :all do
    insert_employees
  end

  it "creates an HTML report" do
    get '/reports/employee'
    expect(response.body).to eq(File.read('spec/fixtures/employee_report.html'))
  end

  it "creates an HTML report" do
    get '/reports/employee', options: {
      salary: true, order: 'desc', 
      names: ['Jimmy Jackalope', 'Moustafa McMann'],
      divisions: ['Tedious Toiling']
    }
    expect(response.body).to eq(File.read('spec/fixtures/customized_employee_report.html'))
  end

end
