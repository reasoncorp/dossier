class AddDivisionToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :division, :string
    add_column :employees, :salary,   :integer
  end
end
