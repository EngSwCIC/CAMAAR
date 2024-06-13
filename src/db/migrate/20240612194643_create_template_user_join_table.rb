class CreateTemplateUserJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :templates_users, id: false do |t|
      t.belongs_to :user
      t.belongs_to :template
    end
  end
end
