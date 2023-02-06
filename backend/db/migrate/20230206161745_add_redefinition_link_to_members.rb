class AddRedefinitionLinkToMembers < ActiveRecord::Migration[7.0]
  def change
    add_column :members, :redefinition_link, :string
  end
end
