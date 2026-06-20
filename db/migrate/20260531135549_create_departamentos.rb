class CreateDepartamentos < ActiveRecord::Migration[8.1]
  def change
    create_table :departamentos do |t|
      t.string :nome_departamento

      t.timestamps
    end
  end
end
