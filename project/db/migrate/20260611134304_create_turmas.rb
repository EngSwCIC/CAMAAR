class CreateTurmas < ActiveRecord::Migration[8.1]
  def change
    create_table :turmas do |t|
      t.string :subject_code
      t.string :subject_name
      t.string :class_code
      t.string :semester
      t.string :time
      t.references :departamento, null: false, foreign_key: true
      t.references :professor, null: false, foreign_key: true

      t.timestamps
    end
  end
end
