class CreateFormulariosClasses < ActiveRecord::Migration[7.1]
  def change
    create_table :formularios_classes do |t|
      t.references :formulario, null: false, foreign_key: true
      t.references :classe, null: false, foreign_key: true

      t.timestamps
    end
  end
end
