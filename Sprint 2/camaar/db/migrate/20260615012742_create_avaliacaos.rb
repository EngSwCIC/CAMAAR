class CreateAvaliacaos < ActiveRecord::Migration[7.1]
  def change
    create_table :avaliacaos do |t|
      t.datetime :data_inicio
      t.datetime :data_fim
      t.references :template, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true

      t.timestamps
    end
  end
end
