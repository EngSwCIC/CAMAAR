class CreateDisciplinesSignUpAvailables < ActiveRecord::Migration[6.0]
  def change
    create_table :disciplines_sign_up_availables do |t|
      t.string :discipline_code
      t.string :registration_number

      t.timestamps
    end
    add_index :disciplines_sign_up_availables, :discipline_code
    add_index :disciplines_sign_up_availables, :registration_number
  end
end
