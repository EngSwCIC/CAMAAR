class AddTemplateToFormRequest < ActiveRecord::Migration[7.1]
  def change
    add_belongs_to :form_requests, :template
  end
end
