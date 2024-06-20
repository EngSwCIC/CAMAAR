class CreateJoinTableStudyClassUsers < ActiveRecord::Migration[7.1]
  def change
    create_join_table :study_classes, :users do |t|
      t.index :study_class_id
      t.index :user_id
    end
  end
end
