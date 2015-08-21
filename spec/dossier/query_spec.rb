require 'spec_helper'

describe Dossier::Query do

  let(:report) { TestReport.new(:foo => 'bar') }
  let(:query)  { Dossier::Query.new(report) }

  before :each do
    allow(report).to receive(:salary).and_return(2)
    allow(report).to receive(:ids).and_return([1,2,3])
  end

  describe "replacing symbols by calling methods of the same name" do

    context "when it's a normal symbol match" do

      context "when the methods return single values" do

        before :each do
          allow(report).to receive(:sql).and_return("SELECT * FROM employees WHERE id = :id OR girth < :girth OR hired_on = :hired_on")
          allow(report).to receive(:id).and_return(92)
          allow(report).to receive(:girth).and_return(3.14)
          allow(report).to receive(:hired_on).and_return('2013-03-29')
        end

        it "escapes the values" do
          expect(query).to receive(:escape).with(92)
          expect(query).to receive(:escape).with(3.14)
          expect(query).to receive(:escape).with('2013-03-29')
          query.to_s
        end

        it "inserts the values" do
          expect(query.to_s).to eq("SELECT * FROM employees WHERE id = 92 OR girth < 3.14 OR hired_on = '2013-03-29'")
        end

      end

      context "when the methods return arrays" do

        before :each do
          allow(report).to receive(:sql).and_return("SELECT * FROM employees WHERE stuff IN :stuff")
          allow(report).to receive(:stuff).and_return([38, 'blue', 'mandible', 2])
        end

        it "escapes each value in the array" do
          expect(Dossier.client).to receive(:escape).with(38)
          expect(Dossier.client).to receive(:escape).with('blue')
          expect(Dossier.client).to receive(:escape).with('mandible')
          expect(Dossier.client).to receive(:escape).with(2)
          query.to_s
        end

        it "joins the return values with commas" do
          expect(query.to_s).to eq("SELECT * FROM employees WHERE stuff IN (38, 'blue', 'mandible', 2)")
        end
      end
    end

    context "when it's another string that includes :" do

      it "does not escape a namespaced constant" do
        allow(report).to receive(:sql).and_return("SELECT * FROM employees WHERE type = 'Foo::Bar'") 
        expect(query).not_to receive(:Bar)
        query.to_s
      end

      it "does not escape a top-level constant" do
        allow(report).to receive(:sql).and_return("SELECT * FROM employees WHERE type = '::Foo'") 
        expect(query).not_to receive(:Foo)
        query.to_s
      end

    end

  end

end
