class CreateDisciplinas < ActiveRecord::Migration[7.1]
  def change
    create_table :disciplinas, id:false do |t|
      t.string :nome
      t.string :codigo, primary_key:true

      t.timestamps
    end
  end
end
