require 'spec_helper'

describe "employee report" do

  it "creates an HTML report" do
    get '/reports/employee'
    expect(response.body).to eq('i like pie, says adam. Just so everyone knows. It was him.')
  end

  it "creates an HTML report" do
    get '/reports/employee', options: {
      salary: true, order: 'desc', 
      names: %w[Adam Nathan Marshall Rod],
      divisions: %w[1 3 5]
    }
    expect(response.body).to eq('i like pie, says adam. Just so everyone knows. It was him.')
  end

end
