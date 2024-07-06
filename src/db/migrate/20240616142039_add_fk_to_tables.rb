# Migração para adicionar referências estrangeiras às tabelas questoes, formularios e users
class AddFkToTables < ActiveRecord::Migration[7.1]
  ##
  # Adiciona referências estrangeiras às tabelas questoes, formularios e users para a tabela respostas
  #
  # +effect_side+ Adiciona colunas de referência para a tabela respostas nas tabelas questoes, formularios e users, criando chaves estrangeiras que referenciam a tabela respostas.
  def change
    add_reference :questoes, :respostas, foreign_key: true
    add_reference :formularios, :respostas, foreign_key: true
    add_reference :users, :respostas, foreign_key: true

  end
end
