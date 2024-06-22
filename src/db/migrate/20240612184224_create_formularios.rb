class CreateFormularios < ActiveRecord::Migration[7.1]
  def change
    create_table :formularios do |t|
      t.integer :id_turma
      t.integer :id_template
      
      t.belongs_to :turma, foreign_key: true
      t.belongs_to :template, foreign_key: true

      t.timestamps
    end
  end
end
