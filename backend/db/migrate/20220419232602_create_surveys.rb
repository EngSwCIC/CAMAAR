class CreateSurveys < ActiveRecord::Migration[7.0]
  def change
    create_table :surveys do |t|
      t.string :name
      t.text :description
      t.datetime :expiration_date
      t.string :semester

      t.timestamps
    end
  end
end
