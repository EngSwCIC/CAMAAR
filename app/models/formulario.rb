# app/models/formulario.rb
# frozen_string_literal: true

# == Schema Information
#
# Table name: formularios
#
#  id                  :integer          not null, primary key
#  data_envio          :datetime
#  data_fim            :datetime
#  ativo               :boolean          default(TRUE)
#  template_id         :integer          not null
#  turma_id            :integer
#  coordenador_id      :integer          not null
#  disciplina_id       :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  escopo_visibilidade :integer
#
# Classe responsável por representar formulários de avaliação
class Formulario < ApplicationRecord
  # Associações
  belongs_to :template
  belongs_to :turma, optional: true
  belongs_to :coordenador, class_name: 'User'
  belongs_to :disciplina, optional: true
  has_many :resposta, class_name: 'Respostum', dependent: :destroy
  has_many :submissoes_concluidas, class_name: 'SubmissaoConcluida', dependent: :destroy

  # Enums para controle de visibilidade (com a sintaxe corrigida)
  enum :escopo_visibilidade, {
    todos_os_alunos: 0,
    por_turma: 1,
    por_disciplina: 2,
    por_curso: 3
  }

  # Validações
  validates :data_envio, :data_fim, presence: true
  validates :data_fim, comparison: { greater_than: :data_envio }
  validates :disciplina_id, presence: true, if: -> { por_disciplina? }

  # Delegar público-alvo para o template
  delegate :publico_alvo, to: :template

  # Scopes
  scope :ativos, -> { where(ativo: true) }
  scope :no_periodo, -> { where('data_envio <= ? AND data_fim >= ?', Time.current, Time.current) }

  # Método para verificar se um usuário pode ver este formulário
  #
  # ==== Attributes
  #
  # * +user+ - O usuário a ser verificado.
  #
  # ==== Returns
  #
  # * +Boolean+ - Retorna true se o formulário estiver visível para o usuário, caso contrário, retorna false.
  #
  def can_be_seen_by?(user)
    return false unless ativo? && no_periodo?

    case template.publico_alvo
    when 'professores'
      visible_for_professor?(user)
    when 'alunos'
      visible_for_aluno?(user)
    else
      false
    end
  end

  # Método para verificar se usuário já respondeu
  #
  # ==== Attributes
  #
  # * +user+ - O usuário a ser verificado.
  #
  # ==== Returns
  #
  # * +Boolean+ - Retorna true se o usuário já respondeu ao formulário, caso contrário, retorna false.
  #
  def already_answered_by?(user)
    submissoes_concluidas.exists?(user: user)
  end

  # Alias para already_answered_by? para compatibilidade
  #
  # ==== Attributes
  #
  # * +user+ - O usuário a ser verificado.
  #
  # ==== Returns
  #
  # * +Boolean+ - Retorna true se o usuário já respondeu ao formulário, caso contrário, retorna false.
  #
  def respondido_por?(user)
    already_answered_by?(user)
  end

  private

  def visible_for_professor?(user)
    user.professor? && (todos_os_alunos? || professor_has_access?(user))
  end

  def visible_for_aluno?(user)
    user.aluno? && (todos_os_alunos? || aluno_has_access?(user))
  end

  def professor_has_access?(user)
    por_disciplina? && user.leciona_disciplina?(disciplina_id)
  end

  def aluno_has_access?(user)
    por_disciplina? && user.matriculado_em_disciplina?(disciplina_id)
  end

  def no_periodo?
    Time.current.between?(data_envio, data_fim)
  end
end
