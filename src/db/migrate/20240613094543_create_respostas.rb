# Migração para criar a tabela respostas
class CreateRespostas < ActiveRecord::Migration[7.1]
  ##
  # Cria a tabela respostas com as colunas resposta, numero, e referências às tabelas user, questao e formulario
  #
  # +effect_side+ Cria a tabela respostas com colunas para armazenar a resposta do usuário, o número da resposta, e referências estrangeiras para as tabelas user, questao e formulario, além de timestamps para criação e atualização
  def change
    create_table :respostas do |t|
      t.text :resposta
      t.integer :numero

      t.belongs_to :user, foreign_key: true
      t.belongs_to :questao, foreign_key: true
      t.belongs_to :formulario, foreign_key: true

      t.timestamps
    end
  end
end
