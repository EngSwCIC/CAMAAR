class CreateAvaliacoes < ActiveRecord::Migration[8.1]
  def change
    create_table :avaliacoes do |t|
      t.references :participacao_turma, null: false, foreign_key: true
      t.references :formulario, null: false, foreign_key: true
      t.datetime :respondido_em

      t.timestamps
    end

    add_index :avaliacoes,
      [ :participacao_turma_id, :formulario_id ],
      unique: true
  end
end
