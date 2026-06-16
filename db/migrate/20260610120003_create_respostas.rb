class CreateRespostas < ActiveRecord::Migration[8.1]
  def change
    create_table :respostas do |t|
      t.references :formulario, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.text :valor

      t.timestamps
    end

    add_index :respostas, %i[formulario_id user_id question_id], unique: true, name: "index_respostas_unicas"
  end
end
