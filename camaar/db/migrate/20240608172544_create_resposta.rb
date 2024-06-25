class CreateResposta < ActiveRecord::Migration[7.1]
  def change
    create_table :resposta do |t|

      t.timestamps
    end
  end
end
