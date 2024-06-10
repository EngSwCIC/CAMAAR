class CreateRespostas < ActiveRecord::Migration[7.1]
  def change
    create_table :respostas do |t|
      t.integer :id_questao
      t.integer :id_formulario
      t.integer :id_usuario
      t.text :resposta

      t.timestamps
    end
  end
end
