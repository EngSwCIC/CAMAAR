class CreateMemberCclasses < ActiveRecord::Migration[7.0]
  def change
    create_table :member_cclasses do |t|
      t.references :member, null: false, foreign_key: true
      t.references :cclass, null: false, foreign_key: true
      t.integer :grade

      t.timestamps
    end
  end
end
