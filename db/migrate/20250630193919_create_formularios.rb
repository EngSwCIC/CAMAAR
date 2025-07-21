class CreateFormularios < ActiveRecord::Migration[8.0]
  def change
    create_table :formularios do |t|
      t.references :ligacao_pergunta, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true
      t.string :nome

      t.timestamps
    end
  end
end
