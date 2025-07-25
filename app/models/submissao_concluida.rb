# frozen_string_literal: true

# == Schema Information
#
# Table name: submissoes_concluidas
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  formulario_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  uuid_anonimo  :string
#
# Classe responsável por rastrear quais usuários já responderam quais formulários
class SubmissaoConcluida < ApplicationRecord
  self.table_name = 'submissoes_concluidas'

  belongs_to :user, optional: true
  belongs_to :formulario

  # NOTE: This uniqueness validation might need a database index for better performance
  validates :uuid_anonimo, presence: true, uniqueness: { scope: :formulario_id }
  validates :user_id, uniqueness: { scope: :formulario_id }, allow_nil: true
end
