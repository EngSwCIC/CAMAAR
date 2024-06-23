class DropStudentDisciplinesTable < ActiveRecord::Migration[6.1]
  def up
    drop_table :student_disciplines
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover the dropped table"
  end
end
