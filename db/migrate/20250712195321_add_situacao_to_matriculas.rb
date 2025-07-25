class AddSituacaoToMatriculas < ActiveRecord::Migration[8.0]
  def change
    add_column :matriculas, :situacao, :string, default: 'matriculado', null: false
    add_index :matriculas, :situacao
  end
end
