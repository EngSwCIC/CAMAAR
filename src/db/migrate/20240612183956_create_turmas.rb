# Migração para criar a tabela turmas
class CreateTurmas < ActiveRecord::Migration[7.1]
  ##
  # Cria a tabela turmas com as colunas classCode, semestre, id_professor e uma referência à tabela materia
  #
  # +effect_side+ Cria a tabela turmas com colunas para armazenar o código da turma, semestre, ID do professor, uma referência à matéria, e timestamps para criação e atualização
  def change
    create_table :turmas do |t|
      t.string :classCode
      t.string :semestre
      t.integer :id_professor, null: false
      t.belongs_to :materia, foreign_key: true

      t.timestamps
    end
  end
end
