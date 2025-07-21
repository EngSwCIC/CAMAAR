class CreateFormularioRespondidos < ActiveRecord::Migration[8.0]
  def change
    create_table :formulario_respondidos do |t|
      t.string :email, null: false
      t.references :formulario, null: false, foreign_key: true
      t.timestamps
    end

    add_foreign_key :formulario_respondidos, :pessoas, column: :email, primary_key: :email
    add_index :formulario_respondidos, [:email, :formulario_id], unique: true
  end
end