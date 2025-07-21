class CreateParticipantes < ActiveRecord::Migration[8.0]
  def change
    create_table :participantes do |t|
      t.string :email, null: false
      t.integer :id_turma, null: false
      t.timestamps
    end

    add_foreign_key :participantes, :pessoas, column: :email, primary_key: :email
    add_foreign_key :participantes, :turmas, column: :id_turma, primary_key: :id
    add_index :participantes, [:email, :id_turma], unique: true
  end
end
