class CreateRespostas < ActiveRecord::Migration[7.1]
  def change
    create_table :respostas do |t|
      t.text :resposta
      t.integer :numero

      t.belongs_to :user, foreign_key: true
      t.belongs_to :questao, foreign_key: true
      t.belongs_to :formulario, foreign_key: true

      t.timestamps
    end
  end
end
