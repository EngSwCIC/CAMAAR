class AddDepartmentToCoordinator < ActiveRecord::Migration[7.1]
  def change
    add_reference :coordinators, :department, null: false, foreign_key: true
  end
end
