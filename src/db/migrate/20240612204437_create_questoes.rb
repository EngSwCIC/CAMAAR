# Migração para criar a tabela questoes
class CreateQuestoes < ActiveRecord::Migration[7.1]
  ##
  # Cria a tabela questoes com a coluna tipo
  #
  # +effect_side+ Cria a tabela questoes com uma coluna para armazenar o tipo de questão e timestamps para criação e atualização
  def change
    create_table :questoes do |t|
      t.string :tipo
      
      t.timestamps
    end
  end
end
