# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string
#  role                   :integer
#  matricula              :string
#  curso                  :string
#  departamento           :string
#  formacao               :string
#
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
  #
  # ==== Attributes
  #
  # * +current_user+ - O usuário que está tentando realizar o cadastro.
  #
  # ==== Returns
  #
  # * +Boolean+ - Retorna true se o usuário for um administrador, caso contrário, retorna false.
  #
  def self.can_register?(current_user = nil)
    current_user&.admin? || false
  end

  # Método para retornar disciplinas que o usuário tem acesso
  #
  # ==== Returns
  #
  # * +ActiveRecord::Relation+ - Retorna uma coleção de disciplinas com base no papel do usuário.
  #   - Administradores: todas as disciplinas.
  #   - Professores: disciplinas que lecionam.
  #   - Alunos: disciplinas em que estão matriculados.
  #
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
  #
  # ==== Attributes
  #
  # * +disciplina_id+ - O ID da disciplina a ser verificada.
  #
  # ==== Returns
  #
  # * +Boolean+ - Retorna true se o usuário for um professor e lecionar a disciplina, caso contrário, retorna false.
  #
  def leciona_disciplina?(disciplina_id)
    return false unless professor?

    disciplinas_como_professor.exists?(id: disciplina_id)
  end

  # Método para verificar se aluno está matriculado em uma disciplina específica
  #
  # ==== Attributes
  #
  # * +disciplina_id+ - O ID da disciplina a ser verificada.
  #
  # ==== Returns
  #
  # * +Boolean+ - Retorna true se o usuário for um aluno e estiver matriculado na disciplina, caso contrário, retorna false.
  #
  def matriculado_em_disciplina?(disciplina_id)
    return false unless aluno?

    disciplinas_como_aluno.exists?(id: disciplina_id)
  end

  # Método para verificar se aluno está matriculado em uma turma específica
  #
  # ==== Attributes
  #
  # * +turma_id+ - O ID da turma a ser verificada.
  #
  # ==== Returns
  #
  # * +Boolean+ - Retorna true se o usuário for um aluno e estiver matriculado na turma, caso contrário, retorna false.
  #
  def matriculado_em_turma?(turma_id)
    return false unless aluno?

    matriculas.exists?(turma_id: turma_id)
  end

  # Método para verificar se o usuário não tem senha definida
  #
  # ==== Returns
  #
  # * +Boolean+ - Retorna true se o usuário não tiver uma senha criptografada, caso contrário, retorna false.
  #
  def sem_senha?
    encrypted_password.blank?
  end

  # Método para definir primeira senha (sem validação de senha atual)
  #
  # ==== Attributes
  #
  # * +nova_senha+ - A nova senha a ser definida.
  # * +confirmacao_senha+ - A confirmação da nova senha.
  #
  # ==== Returns
  #
  # * +Boolean+ - Retorna true se a senha for definida com sucesso, caso contrário, retorna false.
  #
  # ==== Side Effects
  #
  # * Altera a senha do usuário no banco de dados se as validações passarem.
  #
  def definir_primeira_senha(nova_senha, confirmacao_senha)
    return false unless sem_senha?
    return false if nova_senha != confirmacao_senha
    return false if nova_senha.length < 6

    self.password = nova_senha
    self.password_confirmation = confirmacao_senha
    save
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
