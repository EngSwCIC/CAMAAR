class User < ApplicationRecord
  # O devise_invitable cuida do envio do e-mail para definição de senha
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :validatable

  # Regras para impedir o banco de salvar dados vazios ou repetidos
  validates :nome, presence: true
  validates :matricula, presence: true, uniqueness: true
  validates :perfil, presence: true, inclusion: { in: %w[docente discente] }

  has_many :enrollments, dependent: :destroy
  has_many :turmas, through: :enrollments
  has_many :respostas, dependent: :destroy

  # Docente atua como administrador/gestor; discente apenas responde
  def docente?
    perfil == "docente"
  end
  alias_method :admin?, :docente?

  def discente?
    perfil == "discente"
  end
end