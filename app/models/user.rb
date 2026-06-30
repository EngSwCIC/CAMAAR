##
# Define a model User, representando um usuário do sistema, com suas associações, validações e métodos auxiliares, usando o Devise.
# == Schema:
#  * id: integer, primary key
#  * nome: string, nome do usuário
#  * matricula: string, matrícula do usuário
#  * email: string, e-mail do usuário
#  * encrypted_password: string, senha criptografada (Devise)
#  * perfil: string, perfil do usuário (docente ou discente)
#  * departamento: string, departamento do usuário
class User < ApplicationRecord
  # Step definitions (BDD) usam "department"; o banco usa "departamento".
  alias_attribute :department, :departamento

  # O devise_invitable cuida do envio do e-mail para definição de senha
  devise :invitable, :database_authenticatable, :recoverable, :rememberable, :validatable

  before_validation { self.email = email.downcase if email.present? }
  
  # Regras para impedir o banco de salvar dados vazios ou repetidos
  validates :nome, presence: true
  validates :matricula, presence: true, uniqueness: true
  validates :perfil, presence: true, inclusion: { in: %w[docente discente] }

  has_many :enrollments, dependent: :destroy
  has_many :turmas, through: :enrollments
  has_many :respostas, dependent: :destroy

  def docente? #:nodoc:
    perfil == "docente"
  end
  alias_method :admin?, :docente?

  def discente? #:nodoc:
    perfil == "discente"
  end

  ##
  # a. Descrição: Recupera (por e-mail) ou convida um usuário a partir de uma linha de CSV do SIGAA.
  # b. Argumentos: Recebe 'row' (Hash) com as colunas 'email', 'nome', 'matricula' e 'perfil'.
  # c. Retorno: Retorna o User encontrado ou o recém-convidado.
  # d. Efeitos colaterais: Cria um User e envia o e-mail de convite quando o e-mail ainda não existe.
  def self.find_or_invite_from_row(row)
    return find_by(email: row["email"]) if exists?(email: row["email"])

    invite!(
      nome: row["nome"],
      email: row["email"],
      matricula: row["matricula"],
      perfil: row["perfil"]
    )
  end

  ##
  # a. Descrição: Recupera (por e-mail) ou convida um usuário a partir de um membro do JSON do SIGAA.
  # b. Argumentos: Recebe 'pessoa' (Hash) com 'email', 'nome', 'matricula'/'usuario' e 'perfil' (String).
  # c. Retorno: Retorna o User encontrado ou o recém-convidado.
  # d. Efeitos colaterais: Cria um User e envia o e-mail de convite quando o e-mail ainda não existe.
  def self.find_or_invite_from_pessoa(pessoa, perfil)
    email = pessoa["email"].to_s.downcase
    return find_by(email: email) if exists?(email: email)

    invite!(
      nome: pessoa["nome"],
      email: email,
      matricula: pessoa["matricula"].presence || pessoa["usuario"],
      perfil: perfil
    )
  end

end
