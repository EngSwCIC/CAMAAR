class CreateStudentDisciplines2 < ActiveRecord::Migration[7.1]
    def change
      create_table :student_disciplines do |t|
        
        t.string :student_email, null: false
        t.string :discipline_code, null: false
        t.integer :semester_id, null: false
  
        t.timestamps
      end
    end
  end
