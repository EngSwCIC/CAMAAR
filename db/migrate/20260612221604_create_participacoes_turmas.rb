class CreateParticipacoesTurmas < ActiveRecord::Migration[8.1]
  def change
    create_table :participacoes_turmas do |t|
      t.references :usuario, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true
      t.integer :tipo_participacao, null: false

      t.timestamps
    end

    add_index :participacoes_turmas,
      [ :usuario_id, :turma_id, :tipo_participacao ],
      unique: true
  end
end
