require 'spec_helper'

describe Dossier::Condition do

  it "will escape values when binding into a sql fragment" do
    condition = Dossier::Condition.new("name = :name", :name => %q[O'neil])
    condition.to_s.should eq(%q[name = 'O\'neil'])
  end

  it "will escape and then join an array when binding into a sql fragment" do
    condition = Dossier::Condition.new("state_abbr in (:states)", :states => %w[TN NC WA MI])
    condition.to_s.should eq("state_abbr in ('TN','NC','WA','MI')") 
  end

  it "will raise an argument error when trying to bind an object that is not an Array, String or Fixnum" do 
    condition = Dossier::Condition.new("foo = :bar", :bar => Set.new)
    message = "bound values may only be an Array, String, or Fixnum; you provided a Set (#<Set: {}>)."
    expect { condition.to_s }.to raise_error(ArgumentError, message)
  end

  it "will bind all the given binds into the provided fragment" do
    condition = Dossier::Condition.new("foo = :bar and baz = :bat or bing in (:bong)", :bar => 'bar', :bat => 'bat', :bong => %w[bong bang boom])
    condition.to_s.should eq("foo = 'bar' and baz = 'bat' or bing in ('bong','bang','boom')")
  end

  it "will replace all occurences of the bind inside of the fragment" do
    condition = Dossier::Condition.new("foo = :bar and baz = :bar", :bar => 'bar')
    condition.to_s.should eq("foo = 'bar' and baz = 'bar'")
  end

  it "will return the fragment if there are no binds" do
    condition = Dossier::Condition.new("foo = 'bar'")
    condition.to_s.should eq("foo = 'bar'")
  end

  it "will be blank if the fragment is blank" do
    condition = Dossier::Condition.new('')
    condition.should be_blank
  end
end
