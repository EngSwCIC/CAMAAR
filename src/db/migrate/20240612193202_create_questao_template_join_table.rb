class CreateQuestaoTemplateJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :questoes_templates, id: false do |t|
      t.belongs_to :questao
      t.belongs_to :template
    end
  end
end
