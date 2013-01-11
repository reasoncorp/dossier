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
    expect {report.query}.to raise_error(NotImplementedError)
  end

  describe "DSL" do

    describe "query" do

      describe "build_query" do

        before :each do
          report.stub(:salary).and_return(2)
          report.stub(:ids).and_return([1,2,3])
        end

        describe "replacing symbols by calling methods of the same name" do

          context "when the method returns a Numeric" do

            before :each do
              report.stub(:query).and_return("SELECT * FROM employees WHERE id = :id OR girth < :girth")
              report.stub(:id).and_return(92)
              report.stub(:girth).and_return(3.14)
            end

            it "inserts the numeric as-is" do
              expect(report.build_query).to eq("SELECT * FROM employees WHERE id = 92 OR girth < 3.14")
            end

          end

          context "when the method returns an array" do

            before :each do
              report.stub(:query).and_return("SELECT * FROM employees WHERE stuff = :stuff")
              report.stub(:stuff).and_return([38, 'blue', 'mandible', 2])
            end

            it "escapes each individual string" do
              Dossier.client.should_receive(:escape).with('blue')
              Dossier.client.should_receive(:escape).with('mandible')
              report.build_query
            end

            it "joins the return values with commas" do
              report.build_query.should eq("SELECT * FROM employees WHERE stuff = 38, 'blue', 'mandible', 2")
            end

          end

          context "when the method returns anything else" do

            before :each do
              report.stub(:query).and_return("SELECT * FROM employees WHERE name = :name")
              report.stub(:name).and_return(:Jimmy)
            end

            it "coerces it to a string and escapes it" do
              Dossier.client.should_receive(:escape).with('Jimmy')
              report.build_query
            end

            it "quotes the escaped string" do
              expect(report.build_query).to eq("SELECT * FROM employees WHERE name = 'Jimmy'")
            end

          end

        end

      end

    end

    describe "run" do
      it "will execute the generated sql query" do
        @report = EmployeeReport.new
        Dossier.client.should_receive(:query).with(@report.build_query).and_return([])
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
