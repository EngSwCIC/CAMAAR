class Usuario < ApplicationRecord
  has_secure_password(validations: false)
  # Sobrescreve o tempo de expiração de 15 minutos para 48h do has_secure_password
  # Abrange tanto o primeiro acesso quanto o acesso de reset de esquecer senha
  # Token é automaticamente invalidado quando o password_digest muda
  generates_token_for :password_reset, expires_in: 48.hours do
    password_digest
  end

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

  #Apenas validado quando a senha está explicitamente sendo definida (e não importada)
  with_options if: -> { password.present? } do
    validates :password, length: { maximum: 72.bytes }
    validates :password, confirmation: { allow_nil: true }
    validates :password_confirmation, presence: { message: "é obrigatória" }, on: :create
    validate  :password_meets_complexity_requirements
  end

  private

  def normalize_email
    self.email = email.to_s.downcase.strip
  end

  def password_meets_complexity_requirements
    return if password.length >= 8 && password.match?(/[A-Za-z]/) && password.match?(/\d/)

    errors.add(:password, "deve ter no mínimo 8 caracteres, incluindo letras e números")
  end
end
