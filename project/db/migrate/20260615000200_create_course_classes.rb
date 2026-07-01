class CreateCourseClasses < ActiveRecord::Migration[8.1]
  def change
    create_table :course_classes do |t|
      t.references :department, null: false, foreign_key: true
      t.string :code, null: false
      t.string :name
      t.string :class_code, null: false
      t.string :semester, null: false

      t.timestamps
    end

    add_index :course_classes, [ :code, :class_code, :semester ], unique: true
  end
end
