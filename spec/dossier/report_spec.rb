require 'spec_helper'

describe Dossier::Report do

  let(:report) { TestReport.new(:foo => 'bar') }

  describe "report instances" do
    it "takes options when initializing" do
      report = TestReport.new(:foo => 'bar')
      report.options.should eq('foo' => 'bar')
    end
  end

  describe "callbacks" do

    let(:report) do
      Class.new(Dossier::Report) do
        set_callback :build_query, :before, :before_test_for_build_query
        set_callback :execute, :after, :after_test_for_execute

        def sql; ''; end
      end.new
    end

    it "has callbacks for build_query" do
      report.should_receive(:before_test_for_build_query)
      report.query
    end

    it "has callbacks for execute" do
      Dossier.client.stub(:execute).and_return([])
      report.stub(:before_test_for_build_query)
      report.should_receive(:after_test_for_execute)
      report.run
    end

  end

  it "requires you to override the query method" do
    expect {report.sql}.to raise_error(NotImplementedError)
  end

  describe "DSL" do

    describe "run" do
      it "will execute the generated sql query" do
        report = EmployeeReport.new
        Dossier.client.should_receive(:execute).with(report.query, 'EmployeeReport').and_return([])
        report.run
      end

      it "will cache the results of the run in `results`" do
        report = EmployeeReport.new
        report.run
        report.results.should_not be_nil
      end
    end

    describe "view" do
      it "will infer its view name from the class name" do
        EmployeeReport.new.view.should eq("employee")
      end
    end

  end

end
