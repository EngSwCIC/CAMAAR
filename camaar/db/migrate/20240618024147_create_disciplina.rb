class CreateDisciplina < ActiveRecord::Migration[7.1]
  def change
    create_table :disciplinas do |t|

      t.timestamps
    end
  end
end
