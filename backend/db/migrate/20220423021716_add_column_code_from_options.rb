class AddColumnCodeFromOptions < ActiveRecord::Migration[7.0]
  def change 
    add_column :options, :code, :integer
  end
end
