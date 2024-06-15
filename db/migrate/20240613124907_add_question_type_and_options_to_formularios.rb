class AddQuestionTypeAndOptionsToFormularios < ActiveRecord::Migration[7.1]
  def change
    add_column :formularios, :question_type, :string
    add_column :formularios, :options, :json
  end
end
