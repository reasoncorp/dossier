require 'spec_helper'

describe Dossier::Query do

  let(:report) { TestReport.new(:foo => 'bar') }
  let(:query)  { Dossier::Query.new(report) }

  before :each do
    report.stub(:salary).and_return(2)
    report.stub(:ids).and_return([1,2,3])
  end

  describe "replacing symbols by calling methods of the same name" do

    context "when it's a normal symbol match" do

      context "when the methods return single values" do

        before :each do
          report.stub(:sql).and_return("SELECT * FROM employees WHERE id = :id OR girth < :girth OR hired_on = :hired_on")
          report.stub(:id).and_return(92)
          report.stub(:girth).and_return(3.14)
          report.stub(:hired_on).and_return('2013-03-29')
        end

        it "escapes the values" do
          query.should_receive(:escape).with(92)
          query.should_receive(:escape).with(3.14)
          query.should_receive(:escape).with('2013-03-29')
          query.to_s
        end

        it "inserts the values" do
          expect(query.to_s).to eq("SELECT * FROM employees WHERE id = 92 OR girth < 3.14 OR hired_on = '2013-03-29'")
        end

      end

      context "when the methods return arrays" do

        before :each do
          report.stub(:sql).and_return("SELECT * FROM employees WHERE stuff IN :stuff")
          report.stub(:stuff).and_return([38, 'blue', 'mandible', 2])
        end

        it "escapes each value in the array" do
          Dossier.client.should_receive(:escape).with(38)
          Dossier.client.should_receive(:escape).with('blue')
          Dossier.client.should_receive(:escape).with('mandible')
          Dossier.client.should_receive(:escape).with(2)
          query.to_s
        end

        it "joins the return values with commas" do
          expect(query.to_s).to eq("SELECT * FROM employees WHERE stuff IN (38, 'blue', 'mandible', 2)")
        end
      end
    end

    context "when it's another string that includes :" do

      it "does not escape a namespaced constant" do
        report.stub(:sql).and_return("SELECT * FROM employees WHERE type = 'Foo::Bar'") 
        query.should_not_receive(:Bar)
        query.to_s
      end

      it "does not escape a top-level constant" do
        report.stub(:sql).and_return("SELECT * FROM employees WHERE type = '::Foo'") 
        query.should_not_receive(:Foo)
        query.to_s
      end

    end

  end

end
