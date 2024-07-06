# Migração para adicionar campos de confirmação à tabela users
class AddConfirmableToUser < ActiveRecord::Migration[7.1]
  ##
  # Adiciona colunas relacionadas à confirmação de usuários na tabela users
  #
  # +effect_side+ Adiciona colunas para o token de confirmação, data e hora de confirmação, data e hora do envio da confirmação e e-mail não confirmado à tabela users. Também adiciona um índice único no campo confirmation_token.
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at,       :datetime
    add_column :users, :confirmation_sent_at , :datetime
    add_column :users, :unconfirmed_email, :string

    add_index  :users, :confirmation_token, :unique => true
  end
end
