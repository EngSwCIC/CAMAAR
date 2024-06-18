class AddFormatToQuestion < ActiveRecord::Migration[7.1]
  def change
    add_column :questions, :format, :string
  end
end
