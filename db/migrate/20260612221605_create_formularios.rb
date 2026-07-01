class CreateFormularios < ActiveRecord::Migration[8.1]
  def change
    create_table :formularios do |t|
      t.references :adm, null: false, foreign_key: { to_table: :perfis_adm }
      t.references :turma, null: false, foreign_key: true
      t.references :template, null: true, foreign_key: true
      t.integer :publico_alvo, null: false
      t.datetime :criado_em, null: false

      t.timestamps
    end
  end
end
