class CreateTurmas < ActiveRecord::Migration[7.1]
  def change
    create_table :turmas do |t|

      t.timestamps
    end
  end
end
