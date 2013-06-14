require 'spec_helper'

describe "employee report" do

  describe "rendering HTML" do

    context "displaying headers" do
      it "titleizes the headers by default" do
        visit '/reports/employee'
        expect(page).to have_content('Name')
        expect(page).to_not have_content('name')
      end
    end

    context "when a custom view exists for the report" do

      it "uses the custom view" do
        visit '/reports/employee_with_custom_view'
        expect(page).to have_content('Yeah. Did you get that memo?')
      end

      it "has access to the reports formatter in the view scope" do
        visit '/reports/employee_with_custom_view'
        expect(page).to have_content('Margery Butts')
      end

    end

    context "when no custom view exists for the report" do
      let(:path) { dossier_report_path(report: 'employee', options: options) }
      let(:options) { nil }

      it "creates an HTML report using its standard 'show' view" do
        visit path
        expect(page).to have_selector("table thead tr", count: 1)
        expect(page).to have_selector("table tbody tr", count: 3)
      end

      describe "with options for filtering" do
        let(:options) { {
          salary: true, order: 'desc', 
          names: ['Jimmy Jackalope', 'Moustafa McMann'],
          divisions: ['Tedious Toiling']
        } }

        it "uses any options provided" do
          visit path
          expect(page).to have_selector("table tbody tr", count: 1)
          expect(page).to have_selector("td", text: 'Employee Jimmy Jackalope, Jr.')
        end
      end

      describe "with a footer" do
        let(:options) { {footer: 1} }

        it "moves the specified number of rows into the footer" do
          visit path
          expect(page).to have_selector("table tfoot tr th", text: 'Employee Moustafa McMann')
        end
      end

    end

  end

  describe "rendering CSV" do

    it "creates a standard CSV report" do
      visit '/reports/employee.csv'
      expect(page.body).to eq(File.read('spec/fixtures/reports/employee.csv'))
    end

  end

  describe "rendering XLS" do

    it "creates a standard XLS report" do
      visit '/reports/employee.xls'
      expect(page.body).to eq(File.read('spec/fixtures/reports/employee.xls'))
    end

  end

end
