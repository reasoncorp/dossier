class CreateEmployees < ActiveRecord::Migration
  def up
    create_table :employees do |t|
      t.string  :name
      t.date    :hired_on
      t.boolean :suspended
    end
  end

  def down
    drop_table :employees
  end
end
