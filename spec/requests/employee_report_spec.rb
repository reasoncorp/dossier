require 'spec_helper'

describe "employee report" do

  before :all do
    insert_employees
  end

  describe "rendering HTML" do

    context "when a custom view exists for the report" do

      it "uses the custom view" do
        get '/reports/suspended_employee'
        expect(response.body).to include('<h1>Yeah. Did you get that memo?</h1>')
      end

    end

    context "when no custom view exists for the report" do

      it "creates an HTML report using its standard 'show' view" do
        get '/reports/employee'
        expect(response.body).to eq(File.read('spec/fixtures/employee_report.html'))
      end

      it "uses any options provided" do
        get '/reports/employee', options: {
          salary: true, order: 'desc', 
          names: ['Jimmy Jackalope', 'Moustafa McMann'],
          divisions: ['Tedious Toiling']
        }
        expect(response.body).to eq(File.read('spec/fixtures/customized_employee_report.html'))
      end

      it "moves the specified number of rows into the footer" do
        get '/reports/employee', options: {
          footer: 1
        }
        expect(response.body).to eq(File.read('spec/fixtures/employee_report_with_footer.html'))
      end

    end

  end

  describe "rendering CSV" do

    it "creates a standard CSV report" do
      get '/reports/employee.csv'
      expect(response.body).to eq(File.read('spec/fixtures/employee_report.csv'))
    end

  end

end
