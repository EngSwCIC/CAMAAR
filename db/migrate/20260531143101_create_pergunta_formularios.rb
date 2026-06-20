class CreatePerguntaFormularios < ActiveRecord::Migration[8.1]
  def change
    create_table :pergunta_formularios do |t|
      t.references :formulario, null: false, foreign_key: true
      t.references :pergunta, null: false, foreign_key: { to_table: :pergunta }

      t.timestamps
    end
  end
end
