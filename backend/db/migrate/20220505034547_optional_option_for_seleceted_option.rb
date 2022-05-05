class OptionalOptionForSelecetedOption < ActiveRecord::Migration[7.0]
  def change
    change_column_null :selected_options, :option_id, true
  end
end
