class CreateFormularios < ActiveRecord::Migration[6.1]
  def change
    create_table :formularios do |t|
      # Que tipo seria turmas? :turmas, null:false
      t.string :dataDeTermino, null:false
      #Que tipo seria resultados? :resultados, null:false

      t.timestamps
    end
  end
end
