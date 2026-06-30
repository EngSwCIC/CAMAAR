class CreateRespostaFormularios < ActiveRecord::Migration[8.1]
  def change
    create_table :resposta_formularios do |t|
      t.datetime :data_resposta
      t.references :formulario, null: false, foreign_key: true
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
