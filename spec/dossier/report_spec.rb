require 'spec_helper'

describe Dossier::Report do

  let(:report) { TestReport.new(:foo => 'bar') }

  it "has a report name" do
    expect(TestReport.report_name).to eq('test')
  end

  it "has a template name that is the report name" do
    expect(report.template).to eq(report.report_name)
  end

  it "allows overriding the template" do
    report = Class.new(described_class) { def template; 'fooo'; end }
    expect(report.new.template).to eq 'fooo'
  end

  describe "report instances" do
    let(:report_with_custom_header) do
      Class.new(Dossier::Report) do
        def format_header(header)
          {
            'generic' => 'customized'
          }[header.to_s] || super
        end
      end.new
    end

    it "takes options when initializing" do
      expect(report.options).to eq('foo' => 'bar')
    end

    it 'generates column headers' do
      expect(report.format_header('Foo')).to eq 'Foo'
    end

    it 'allows for column header customization' do
      expect(report_with_custom_header.format_header(:generic)).to eq 'customized'
    end

    it "has a formatted title" do
      expect(report.formatted_title).to eq 'Test Report'
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
      expect(report).to receive(:before_test_for_build_query)
      report.query
    end

    it "has callbacks for execute" do
      allow(Dossier.client).to receive(:execute).and_return([])
      allow(report).to receive(:before_test_for_build_query)
      expect(report).to receive(:after_test_for_execute)
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
        expect(Dossier.client).to receive(:execute).with(report.query, 'EmployeeReport').and_return([])
        report.run
      end

      it "will cache the results of the run in `results`" do
        report = EmployeeReport.new
        report.run
        expect(report.results).not_to be_nil
      end
    end

  end
end
