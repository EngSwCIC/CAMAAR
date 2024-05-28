class CreateCoordinators < ActiveRecord::Migration[7.1]
  def change
    create_table :coordinators do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
    add_index :coordinators, :email, unique: true
  end
end
