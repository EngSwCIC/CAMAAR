class CreateQuestoesTemplate < ActiveRecord::Migration[8.1]
  def change
    create_table :questoes_template do |t|
      t.bigint  :template_id, null: false
      t.integer :ordem,       null: false
      t.text    :enunciado,   null: false
      t.string  :tipo,        limit: 20, null: false
      t.boolean :obrigatoria,            null: false, default: true

      t.timestamps
    end

    add_index :questoes_template, [ :template_id, :ordem ], unique: true

    add_foreign_key :questoes_template, :templates, column: :template_id
  end
end
