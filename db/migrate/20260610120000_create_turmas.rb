class CreateTurmas < ActiveRecord::Migration[8.1]
  def change
    create_table :turmas do |t|
      t.string :code, null: false        # código da disciplina (ex: CIC0097)
      t.string :name, null: false        # nome da disciplina
      t.string :class_code, null: false  # turma (ex: TA)
      t.string :semester, null: false    # semestre (ex: 2021.2)
      t.string :time                     # horário (ex: 35T45)

      t.timestamps
    end

    add_index :turmas, %i[code class_code semester], unique: true, name: "index_turmas_on_code_class_semester"
  end
end
