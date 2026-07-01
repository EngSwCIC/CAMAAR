class CreateOpcoesEscolhidas < ActiveRecord::Migration[8.1]
  def change
    create_table :opcoes_escolhidas do |t|
      t.references :resposta, null: false, foreign_key: true
      t.references :opcao, null: false, foreign_key: true

      t.timestamps
    end

    add_index :opcoes_escolhidas, [ :resposta_id, :opcao_id ], unique: true
  end
end
