class CreateMatriculas < ActiveRecord::Migration[8.1]
  def change
    create_table :matriculas do |t|
      t.bigint :turma_id,       null: false
      t.bigint :usuario_id,     null: false
      t.string :papel_na_turma, limit: 20, null: false

      t.timestamps
    end

    add_index :matriculas, [ :turma_id, :usuario_id ], unique: true
    add_index :matriculas, :usuario_id

    add_foreign_key :matriculas, :turmas,   column: :turma_id
    add_foreign_key :matriculas, :usuarios, column: :usuario_id
  end
end
