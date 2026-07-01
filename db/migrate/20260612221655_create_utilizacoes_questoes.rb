class CreateUtilizacoesQuestoes < ActiveRecord::Migration[8.1]
  def change
    create_table :utilizacoes_questoes do |t|
      t.references :template, null: false, foreign_key: true
      t.references :questao, null: false, foreign_key: true
      t.references :parent,
        null: true,
        foreign_key: { to_table: :utilizacoes_questoes }
      t.integer :numero, null: false

      t.timestamps
    end

    add_index :utilizacoes_questoes,
      [ :template_id, :parent_id, :numero ],
      unique: true,
      where: "parent_id IS NOT NULL"

    add_index :utilizacoes_questoes,
      [ :template_id, :numero ],
      unique: true,
      where: "parent_id IS NULL"

    add_index :utilizacoes_questoes,
      [ :template_id, :parent_id, :questao_id ],
      unique: true,
      where: "parent_id IS NOT NULL"

    add_index :utilizacoes_questoes,
      [ :template_id, :questao_id ],
      unique: true,
      where: "parent_id IS NULL"
  end
end
