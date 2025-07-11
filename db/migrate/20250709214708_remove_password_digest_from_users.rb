# frozen_string_literal: true

class RemovePasswordDigestFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :password_digest, :string
  end
end
