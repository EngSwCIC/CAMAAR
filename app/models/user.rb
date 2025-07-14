# frozen_string_literal: true

# Model representing a user of the system
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enum para roles: 0 = admin, 1 = aluno, 2 = professor, 3 = coordenador
  enum :role, { admin: 0, aluno: 1, professor: 2, coordenador: 3 }

  # Associations
  has_many :templates, foreign_key: 'criado_por_id', dependent: :destroy
  has_many :formularios, foreign_key: 'coordenador_id', dependent: :destroy
  has_many :turmas, foreign_key: 'professor_id', dependent: :destroy
  has_many :matriculas, dependent: :destroy
  has_many :submissoes_concluidas, class_name: 'SubmissaoConcluida', dependent: :destroy
  
  # Associações específicas para professores
  has_many :turmas_como_professor, class_name: 'Turma', foreign_key: 'professor_id', dependent: :destroy
  has_many :disciplinas_como_professor, through: :turmas_como_professor, source: :disciplina
  
  # Associações específicas para alunos
  has_many :turmas_matriculadas, through: :matriculas, source: :turma
  has_many :disciplinas_como_aluno, through: :turmas_matriculadas, source: :disciplina

  validates :name, presence: true
  validates :matricula, presence: true, uniqueness: true
  validates :role, presence: true

  # Validações opcionais para campos importados
  validates :curso, length: { maximum: 255 }, allow_blank: true
  validates :departamento, length: { maximum: 255 }, allow_blank: true
  validates :formacao, length: { maximum: 100 }, allow_blank: true

  before_save :downcase_email

  # Permite que apenas admins cadastrem novos usuários
  def self.can_register?(current_user = nil)
    current_user&.admin?
  end

  # Método para retornar disciplinas que o usuário tem acesso
  def disciplinas
    case role
    when 'admin'
      # Admin tem acesso a todas as disciplinas
      Disciplina.all
    when 'professor'
      # Professor tem acesso às disciplinas que leciona
      disciplinas_como_professor
    when 'aluno'
      # Aluno tem acesso às disciplinas que está matriculado
      disciplinas_como_aluno
    else
      # Outros roles não têm acesso
      Disciplina.none
    end
  end
  
  # Método para verificar se professor leciona uma disciplina específica
  def leciona_disciplina?(disciplina_id)
    return false unless professor?
    disciplinas_como_professor.exists?(id: disciplina_id)
  end
  
  # Método para verificar se aluno está matriculado em uma disciplina específica
  def matriculado_em_disciplina?(disciplina_id)
    return false unless aluno?
    disciplinas_como_aluno.exists?(id: disciplina_id)
  end
  
  # Método para verificar se aluno está matriculado em uma turma específica
  def matriculado_em_turma?(turma_id)
    return false unless aluno?
    matriculas.exists?(turma_id: turma_id)
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
