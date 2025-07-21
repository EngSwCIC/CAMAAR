class CreateLigacaoPerguntas < ActiveRecord::Migration[8.0]
  def change
    create_table :ligacao_perguntas do |t|
      t.timestamps
    end
  end
end
