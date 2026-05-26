class CreateRespostas < ActiveRecord::Migration[8.1]
  def change
    create_table :respostas do |t|
      t.bigint    :formulario_id, null: false
      t.bigint    :usuario_id,    null: false
      t.timestamp :enviado_em,    null: false

      t.timestamps
    end

    add_index :respostas, [ :formulario_id, :usuario_id ], unique: true
    add_index :respostas, :usuario_id

    add_foreign_key :respostas, :formularios, column: :formulario_id
    add_foreign_key :respostas, :usuarios,    column: :usuario_id
  end
end
