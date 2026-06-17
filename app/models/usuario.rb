class Usuario < ApplicationRecord
  belongs_to :curso, optional: true
  belongs_to :departamento, optional: true
  validates :matricula, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :nome, presence: true

  attr_reader :senha
  attr_accessor :senha_confirmation

  before_save :atualizar_senha_hash, if: -> { senha.present? }
  validate :validar_senha, if: -> { senha.present? }

  def senha=(nova_senha)
    @senha = nova_senha
  end

  def senha_definida?
    senha_hash.present?
  end

  def autenticar_senha(tentativa)
    return false if senha_hash.blank?

    BCrypt::Password.new(senha_hash) == tentativa
  rescue BCrypt::Errors::InvalidHash
    false
  end

  def gerar_definicao_senha_token!
    update!(
      definicao_senha_token: SecureRandom.urlsafe_base64(32),
      definicao_senha_sent_at: Time.current
    )
  end

  def enviar_email_definicao_senha!
    gerar_definicao_senha_token!
    UsuarioMailer.definicao_senha(self).deliver_now
  end

  def gerar_redefinicao_senha_token!
    update!(
      redefinicao_senha_token: SecureRandom.urlsafe_base64(32),
      redefinicao_senha_sent_at: Time.current
    )
  end

  def enviar_email_redefinicao_senha!
    gerar_redefinicao_senha_token!
    UsuarioMailer.redefinicao_senha(self).deliver_now
  end

  def limpar_redefinicao_senha_token!
    update!(redefinicao_senha_token: nil, redefinicao_senha_sent_at: nil)
  end

  def limpar_definicao_senha_token!
    update!(definicao_senha_token: nil, definicao_senha_sent_at: nil)
  end

  private

  def validar_senha
    if senha_confirmation.present? && senha != senha_confirmation
      errors.add(:senha, :confirmation, message: "confirmação não confere")
    end

    if senha.length < 6
      errors.add(:senha, :invalid, message: "senha inválida")
    end
  end

  def atualizar_senha_hash
    self.senha_hash = BCrypt::Password.create(senha)
  end
end
