class CreateCriadorFormularios < ActiveRecord::Migration[8.1]
  def change
    create_table :criador_formularios do |t|
      t.references :usuario, null: false, foreign_key: true

      t.timestamps
    end
  end
end
