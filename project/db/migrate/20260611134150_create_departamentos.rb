class CreateDepartamentos < ActiveRecord::Migration[8.1]
  def change
    create_table :departamentos do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
