# frozen_string_literal: true

# Classe responsável por rastrear quais usuários já responderam quais formulários
class SubmissaoConcluida < ApplicationRecord
  self.table_name = 'submissoes_concluidas'
  
  belongs_to :user, optional: true
  belongs_to :formulario

  validates :uuid_anonimo, presence: true, uniqueness: { scope: :formulario_id }
  validates :user_id, uniqueness: { scope: :formulario_id }, allow_nil: true
end
