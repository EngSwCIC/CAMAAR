# Migração para criar a tabela users_turmas
class CreateUsersTurmas < ActiveRecord::Migration[7.1]
  ##
  # Cria a tabela users_turmas com referências às tabelas user e turma
  #
  # +effect_side+ Cria a tabela users_turmas com referências estrangeiras para as tabelas user e turma, e timestamps para criação e atualização. As referências são obrigatórias (não podem ser nulas).
  def change
    create_table :users_turmas do |t|
      t.references :user, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true

      t.timestamps
    end
  end
end
