require 'spec_helper'

describe Dossier::Report do

  describe "DSL" do
    describe "query" do
      describe "sql" do

        it "takes a string" do
          sql_statement = "SELECT * FROM `employees`"
          SampleReport.sql sql_statement
          SampleReport.instance_variable_get(:@sql_statement).should eq(sql_statement)
        end

      end
    end

    describe "present" do
    end
  end

end
