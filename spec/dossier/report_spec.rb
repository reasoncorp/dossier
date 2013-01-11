require 'spec_helper'

describe Dossier::Report do

  let(:report) { TestReport.new(:foo => 'bar') }

  describe "report instances" do
    it "takes options when initializing" do
      @report = TestReport.new(:foo => 'bar')
      @report.options.should eq('foo' => 'bar')
    end
  end

  it "has callbacks"

  it "requires you to override the query method" do
    expect {report.sql}.to raise_error(NotImplementedError)
  end

  describe "DSL" do

    describe "run" do
      it "will execute the generated sql query" do
        @report = EmployeeReport.new
        Dossier.client.should_receive(:query).with(@report.query).and_return([])
        @report.run
      end

      it "will cache the results of the run in `results`" do
        @report = EmployeeReport.new
        @report.run
        @report.results.should_not be_nil
      end
    end

    describe "view" do
      it "will infer its view name from the class name" do
        EmployeeReport.new.view.should eq("employee")
      end
    end

    describe "headers" do
      it "extracts headers from the result set"
    end

    describe "to_json" do
      it "can output as json"
    end

    describe "to_csv" do
      it "can output as csv"
    end

  end

end
