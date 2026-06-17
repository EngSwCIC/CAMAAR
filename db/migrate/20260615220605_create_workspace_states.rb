class CreateWorkspaceStates < ActiveRecord::Migration[8.1]
  def change
    create_table :workspace_states do |t|
      t.json :data, null: false
      t.timestamps
    end
  end
end
