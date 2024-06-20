class ChangeFormDisciplineRelationship < ActiveRecord::Migration[7.1]
  def change
    drop_table :form_disciplines
    add_reference :forms, :discipline, null: false, foreign_key: true
  end
end
