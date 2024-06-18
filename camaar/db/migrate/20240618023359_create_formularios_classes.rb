class CreateFormulariosClasses < ActiveRecord::Migration[7.1]
  def change
    create_table :formularios_classes, id: false do |t|
      t.string :formulario_nome, null: false
      t.string :classe_class_code, null: false

      t.index [:formulario_nome, :classe_class_code], unique: true
    end

    add_foreign_key :formularios_classes, :formularios, column: :formulario_nome, primary_key: :nome
    add_foreign_key :formularios_classes, :classes, column: :classe_class_code, primary_key: :class_code
  end
end
