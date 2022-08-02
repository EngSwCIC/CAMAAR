class CreateEnrollments < ActiveRecord::Migration[7.0]
  def change
    create_table :enrollments do |t|
      t.references :cclass, null: false, foreign_key: true, type: :bigint
      t.references :member, null: false, foreign_key: true, type: :bigint

      t.timestamps
    end
  end
end
