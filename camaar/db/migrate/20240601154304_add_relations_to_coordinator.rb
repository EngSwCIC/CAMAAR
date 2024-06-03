class AddRelationsToCoordinator < ActiveRecord::Migration[7.1]
  def change
    add_reference :coordinators, :department, null: false, foreign_key: true
    add_reference :coordinators, :admin, null: false, foreign_key: true
    # add_foreign_key :coordinators, :admin_email, :users, column: :email, on_delete: :cascade
  end
end
