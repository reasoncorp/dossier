require 'spec_helper'

describe Dossier::Query do

  let(:report) { TestReport.new(:foo => 'bar') }
  let(:query)  { Dossier::Query.new(report) }

  before :each do
    report.stub(:salary).and_return(2)
    report.stub(:ids).and_return([1,2,3])
  end

  describe "replacing symbols by calling methods of the same name" do

    context "when the method returns a Numeric" do

      before :each do
        report.stub(:sql).and_return("SELECT * FROM employees WHERE id = :id OR girth < :girth")
        report.stub(:id).and_return(92)
        report.stub(:girth).and_return(3.14)
      end

      it "inserts the numeric as-is" do
        expect(query.to_s).to eq("SELECT * FROM employees WHERE id = 92 OR girth < 3.14")
      end

    end

    context "when the method returns an array" do

      before :each do
        report.stub(:sql).and_return("SELECT * FROM employees WHERE stuff = :stuff")
        report.stub(:stuff).and_return([38, 'blue', 'mandible', 2])
      end

      it "escapes each individual string" do
        Dossier.client.should_receive(:escape).with('blue')
        Dossier.client.should_receive(:escape).with('mandible')
        query.to_s
      end

      it "joins the return values with commas" do
        expect(query.to_s).to eq("SELECT * FROM employees WHERE stuff = 38, 'blue', 'mandible', 2")
      end

    end

    context "when the method returns anything else" do

      before :each do
        report.stub(:sql).and_return("SELECT * FROM employees WHERE name = :name")
        report.stub(:name).and_return(:Jimmy)
      end

      it "coerces it to a string and escapes it" do
        Dossier.client.should_receive(:escape).with('Jimmy')
        query.to_s
      end

      it "quotes the escaped string" do
        expect(query.to_s).to eq("SELECT * FROM employees WHERE name = 'Jimmy'")
      end

    end

  end
end
