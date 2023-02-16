class AddAnsweredSurveysToMember < ActiveRecord::Migration[7.0]
  def change
    create_join_table :members, :surveys, table_name: :answered_surveys
  end
end
