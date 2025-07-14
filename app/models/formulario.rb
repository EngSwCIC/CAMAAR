# frozen_string_literal: true

# Classe responsável por representar formulários de avaliação
class Formulario < ApplicationRecord
  # Enums para controle de visibilidade
  enum :escopo_visibilidade, { todos: 0, por_disciplina: 1 }
  
  # Associações
  belongs_to :template
  belongs_to :turma, optional: true
  belongs_to :coordenador, class_name: 'User'
  belongs_to :disciplina, optional: true
  has_many :resposta, class_name: 'Respostum', foreign_key: 'formulario_id', dependent: :destroy
  has_many :submissoes_concluidas, class_name: 'SubmissaoConcluida', dependent: :destroy
  
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
  def can_be_seen_by?(user)
    return false unless ativo? && no_periodo?
    
    case template.publico_alvo
    when 'professores'
      user.professor? && (todos? || (por_disciplina? && user.leciona_disciplina?(disciplina_id)))
    when 'alunos'
      user.aluno? && (todos? || (por_disciplina? && user.matriculado_em_disciplina?(disciplina_id)))
    else
      false
    end
  end
  
  # Método para verificar se usuário já respondeu
  def already_answered_by?(user)
    submissoes_concluidas.exists?(user: user)
  end
  
  private
  
  def no_periodo?
    data_envio <= Time.current && data_fim >= Time.current
  end
end
