class CreateSubjectClassesRelations < ActiveRecord::Migration[7.1]
  def change
    create_table :subject_classes_relations do |t|
      t.references :department, null: false, foreign_key: true
      t.references :teacher, null: false, foreign_key: true

      t.timestamps
    end
  end
end
