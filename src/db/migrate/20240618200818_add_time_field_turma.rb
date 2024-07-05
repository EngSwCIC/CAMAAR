# Migração para adicionar uma coluna de horário à tabela turmas
class AddTimeFieldTurma < ActiveRecord::Migration[7.1]
    ##
  # Adiciona uma coluna de horário à tabela turmas
  #
  # +effect_side+ Adiciona uma nova coluna chamada horario do tipo string à tabela turmas. Esta coluna pode ser usada para armazenar informações sobre o horário das turmas.
  def change
    add_column :turmas, :horario, :string
  end
end
