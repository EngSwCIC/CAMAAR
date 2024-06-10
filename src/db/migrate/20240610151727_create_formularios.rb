class CreateFormularios < ActiveRecord::Migration[7.1]
  def change
    create_table :formularios do |t|
      t.string :codigo
      t.string :turma
      t.boolean :isRespondido

      t.timestamps
    end
  end
end
