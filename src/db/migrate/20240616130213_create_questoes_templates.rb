class CreateQuestoesTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :questoes_templates do |t|
      t.references :questao, null: false, foreign_key: true
      t.references :template, null: false, foreign_key: true

      t.timestamps
    end
  end
end
