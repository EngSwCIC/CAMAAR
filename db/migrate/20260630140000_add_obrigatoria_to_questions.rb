class AddObrigatoriaToQuestions < ActiveRecord::Migration[8.1]
  def change
    add_column :questions, :obrigatoria, :boolean, default: false, null: false
  end
end
