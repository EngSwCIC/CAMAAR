class CreateAlunos < ActiveRecord::Migration[7.1]
  def change
    create_table :alunos do |t|
      t.string :matricula, null: false
      t.jsonb :nomes_turmas_matriculadas, null:false, default: []
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
