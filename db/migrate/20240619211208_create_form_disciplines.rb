class CreateFormDisciplines < ActiveRecord::Migration[7.1]
  def change
    create_table :form_disciplines do |t|
      t.references :form, null: false, foreign_key: true
      t.references :discipline, null: false, foreign_key: true

      t.timestamps
    end

    add_index :form_disciplines, %i[form_id discipline_id], unique: true
  end
end
