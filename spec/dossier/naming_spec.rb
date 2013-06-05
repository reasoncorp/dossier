require 'spec_helper'

describe Dossier::Naming do
  describe "report naming" do
    let(:klass) { HelloMyFriendsReport }
    let(:name)  { 'hello_my_friends' }

    it "converts a report class to a report name" do
      expect(described_class.class_to_name(klass)).to eq(name)
    end

    it "converting a report name to a report class" do
      expect(described_class.name_to_class(name)).to eq(klass)
    end

    describe "with namespaces" do
      let(:klass) { Cats::Are::SuperFunReport }
      let(:name)  { 'cats/are/super_fun' }

      it "converts a report class to a report name" do
        expect(described_class.class_to_name klass).to eq name
      end

      it "converts a report name to a report class" do
        expect(described_class.name_to_class name).to eq klass
      end
    end
  end
end
