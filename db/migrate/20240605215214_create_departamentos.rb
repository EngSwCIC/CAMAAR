class CreateDepartamentos < ActiveRecord::Migration[7.1]
  def change
    create_table :departamentos do |t|
      t.string :nome

      t.timestamps
    end
  end
end
