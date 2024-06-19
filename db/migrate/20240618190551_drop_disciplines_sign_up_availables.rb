class DropDisciplinesSignUpAvailables < ActiveRecord::Migration[6.0]
  def change
    drop_table :disciplines_sign_up_availables do |t|
      t.string :discipline_code
      t.string :registration_number

      t.timestamps
    end
  end
end
