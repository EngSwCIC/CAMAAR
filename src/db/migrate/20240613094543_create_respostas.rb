class CreateRespostas < ActiveRecord::Migration[7.1]
  def change
    create_table :respostas do |t|
      t.text :resposta
      t.integer :numero

      t.timestamps
    end
  end
end
