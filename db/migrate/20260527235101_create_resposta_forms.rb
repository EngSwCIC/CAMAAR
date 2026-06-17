class CreateRespostaForms < ActiveRecord::Migration[8.1]
  def change
    create_table :resposta_forms do |t|
      t.date :data_submissao
      t.references :formulario, null: false, foreign_key: true
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
