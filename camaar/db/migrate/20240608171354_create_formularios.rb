class CreateFormularios < ActiveRecord::Migration[7.1]
  def change
    create_table :formularios do |t|

      t.timestamps
    end
  end
end
