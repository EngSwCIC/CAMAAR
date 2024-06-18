class CreateDisciplinaClasses < ActiveRecord::Migration[7.1]
  def change
    create_table :disciplina_classes, id: false do |t|
      t.string :disciplina_codigo, null: false
      t.string :classe_class_code, null: false

      t.index [:disciplina_codigo, :classe_class_code], unique: true
    end

    add_foreign_key :disciplina_classes, :disciplinas, column: :disciplina_codigo, primary_key: :codigo
    add_foreign_key :disciplina_classes, :classes, column: :classe_class_code, primary_key: :class_code
  end
end
