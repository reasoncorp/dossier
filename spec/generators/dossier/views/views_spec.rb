require 'spec_helper'

require 'generators/dossier/views/views_generator'

describe Dossier::ViewsGenerator, type: :generator  do
  after(:each)  { cleanup }

  let(:path) { Rails.root.join(*%w[app views dossier reports]) }
  let(:file) { raise 'implement in nested context/describe' }
  let(:file_path) { path.join(file) }
  let(:cleanup)   { FileUtils.rm_f file_path }

  context "with no arguments or options" do
    let(:file) { 'show.html.haml' }

    before(:each) { run_generator }

    it "should generate a view file" do
      expect(FileTest.exists? file_path).to be true
    end
  end

  context "with_args: account_tracker" do
    let(:file) { 'account_tracker.html.haml' }

    before(:each) { run_generator %w[account_tracker] }

    it "should generate a edit_account form" do
      expect(FileTest.exists? file_path).to be true
    end 
  end
end
