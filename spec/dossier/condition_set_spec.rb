require 'spec_helper'

describe Dossier::ConditionSet do

  describe "to_sql" do
    before :each do 
      @set = Dossier::ConditionSet.new
    end

    it "removes any blank elements" do
      @set << ""
      @set.send(:compact)
      @set.to_a.should be_empty
    end

    it "casts all of its elements as a string" do
      @set << @mock = mock('Condition')
      @mock.should_receive(:to_s)
      @set.to_sql
    end

    it "wraps each element in parentheses" do
      @set << "foo = 'bar'"
      @set.to_sql.should eq("(foo = 'bar')")
    end

    it "joins all of its elements with ' and '" do
      @set << "foo = 'bar'"
      @set << "salary > 10000"
      @set.to_sql.should eq("(foo = 'bar') and (salary > 10000)")
    end

    it "can join all of its elements with ' or '" do
      @set.glue = 'or'
      @set << "foo = 'bar'"
      @set << "salary > 10000"
      @set.to_sql.should eq("(foo = 'bar') or (salary > 10000)")
    end
  end

end
