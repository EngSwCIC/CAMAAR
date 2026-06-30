class Usuario < ApplicationRecord
  has_secure_password(validations: false)
  # Sobrescreve o tempo de expiração de 15 minutos para 48h do has_secure_password
  # Abrange tanto o primeiro acesso quanto o acesso de reset de esquecer senha
  # Token é automaticamente invalidado quando o password_digest muda
  generates_token_for :password_reset, expires_in: 48.hours do
    password_digest
  end

  # == Cargo
  # Define o cargo do usuário, usado para verificar ao que o usuário tem acesso no sistema:
  # * +admin+   :: Admin é um usuário capaz de criar formularios, e enviá-los à doscentes e discentes. Um admin gerencia um departamento, tendo
  # acesso à todas as suas matérias e respectivas turmas.
  # * +professor+ :: Professor é um usuário que têm acesso à algumas turmas específicas, sendo capaz de criar formulários para discentes,
  # e sendo capaz também de responder formulários de doscentes.
  # * +estudante+   :: Estudante é um usuário que tem acesso à algumas turmas específicas, sendo capaz apenas de responder
  # os formulários de discentes abertos nessas turmas.
  enum :role, {
    admin: 0,
    professor: 1,
    estudante: 2
  }

  has_one :professor
  has_one :admin
  has_one :estudante
  has_one :criador_formulario

  has_many :resposta_formularios

  before_validation :normalize_email

  validates :nome,  presence: { message: "é obrigatório" }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "é inválido" }

  # Apenas validado quando a senha está explicitamente sendo definida (e não importada)
  with_options if: -> { password.present? } do
    validates :password, length: { maximum: 72.bytes }
    validates :password, confirmation: { allow_nil: true }
    validates :password_confirmation, presence: { message: "é obrigatória" }, on: :create
    validate  :password_meets_complexity_requirements
  end

  private

  # Normaliza uma string de email, deixando seus caracteres minúsculos
  # e se livrando de caractéres em branco (espaços, tabs, newlines, etc.).
  #
  # Argumentos:
  # Não recebe argumentos.
  #
  # Retorna:
  # Nil.
  #
  # Efeitos colaterais:
  # Sobrescreve o atributo +email+ do registro com a versão normalizada
  # (callback before_validation; não grava no banco por si só).
  def normalize_email
    self.email = email.to_s.downcase.strip
  end

  # Verifica a segurança de uma senha. Caso a senha tiver mais que 8 caractéres, tiver pelo
  # menos uma letra e pelo menos um dígito, o método simplesmente retorna. Se não, continua
  # e adiciona um erro pedindo por estas especificações.
  #
  # Argumentos:
  # Não recebe argumentos.
  #
  # Retorna:
  # Nil.
  #
  # Efeitos colaterais:
  # Adiciona um erro em :password quando a senha não atende aos requisitos
  # mínimos de complexidade.
  def password_meets_complexity_requirements
    return if password.length >= 8 && password.match?(/[A-Za-z]/) && password.match?(/\d/)

    errors.add(:password, "deve ter no mínimo 8 caracteres, incluindo letras e números")
  end
end
