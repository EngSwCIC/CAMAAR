class CreateDisciplines < ActiveRecord::Migration[6.0]
  def change
    create_table :disciplines do |t|
      t.string :name
      t.string :code
      t.string :professor_registration

      t.timestamps
    end
  end
end