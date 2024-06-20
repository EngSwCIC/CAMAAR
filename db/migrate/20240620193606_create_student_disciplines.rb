class CreateStudentDisciplines < ActiveRecord::Migration[6.1]
  def change
    create_table :student_disciplines do |t|
      t.string :email, null: false
      t.string :code, null: false

      t.timestamps
    end

    add_index :student_disciplines, :email
    add_index :student_disciplines, :code
    add_index :student_disciplines, [:email, :code], unique: true
  end
end
