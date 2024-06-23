class AddSemesterIdToStudentDisciplines < ActiveRecord::Migration[6.1]
  def change
    add_column :student_disciplines, :semester_id, :integer
    add_index :student_disciplines, [:email, :code, :semester_id], unique: true, name: 'index_student_disciplines_on_email_and_code_and_semester_id'
  end
end