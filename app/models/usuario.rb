# Classe base para todos os usuários do sistema (STI).
#
# Gerencia autenticação via BCrypt e tokens de email para definição e
# redefinição de senha. As subclasses concretas são +Administrador+,
# +Docente+ e +Discente+, diferenciadas pela coluna +type+ (Single Table
# Inheritance).
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

  # Armazena a senha em texto plano em atributo virtual para uso nas validações e no hash.
  #
  # @param nova_senha [String] senha em texto plano fornecida pelo usuário
  # @return [String] a mesma senha recebida
  def senha=(nova_senha)
    @senha = nova_senha
  end

  # Verifica se o usuário já possui uma senha cadastrada.
  #
  # @return [Boolean] +true+ se o hash de senha estiver presente, +false+ caso contrário
  def senha_definida?
    senha_hash.present?
  end

  # Verifica se a senha fornecida corresponde ao hash armazenado.
  #
  # @param tentativa [String] senha em texto plano a ser verificada
  # @return [Boolean] +true+ se a senha conferir, +false+ caso contrário ou se o hash
  #   for inválido
  def autenticar_senha(tentativa)
    return false if senha_hash.blank?

    BCrypt::Password.new(senha_hash) == tentativa
  rescue BCrypt::Errors::InvalidHash
    false
  end

  # Gera e persiste um token de definição de senha com a data/hora atual.
  #
  # @return [void]
  # @note Atualiza os campos +definicao_senha_token+ e +definicao_senha_sent_at+
  #   diretamente no banco de dados.
  def gerar_definicao_senha_token!
    update!(
      definicao_senha_token: SecureRandom.urlsafe_base64(32),
      definicao_senha_sent_at: Time.current
    )
  end

  # Gera o token de definição de senha e envia o email correspondente ao usuário.
  #
  # @return [void]
  # @note Chama +gerar_definicao_senha_token!+ e dispara o envio do email via
  #   +UsuarioMailer#definicao_senha+ de forma síncrona.
  def enviar_email_definicao_senha!
    gerar_definicao_senha_token!
    UsuarioMailer.definicao_senha(self).deliver_now
  end

  # Gera e persiste um token de redefinição de senha com a data/hora atual.
  #
  # @return [void]
  # @note Atualiza os campos +redefinicao_senha_token+ e +redefinicao_senha_sent_at+
  #   diretamente no banco de dados.
  def gerar_redefinicao_senha_token!
    update!(
      redefinicao_senha_token: SecureRandom.urlsafe_base64(32),
      redefinicao_senha_sent_at: Time.current
    )
  end

  # Gera o token de redefinição de senha e envia o email correspondente ao usuário.
  #
  # @return [void]
  # @note Chama +gerar_redefinicao_senha_token!+ e dispara o envio do email via
  #   +UsuarioMailer#redefinicao_senha+ de forma síncrona.
  def enviar_email_redefinicao_senha!
    gerar_redefinicao_senha_token!
    UsuarioMailer.redefinicao_senha(self).deliver_now
  end

  # Remove o token de redefinição de senha e a data de envio do banco de dados.
  #
  # @return [void]
  # @note Define +redefinicao_senha_token+ e +redefinicao_senha_sent_at+ como +nil+.
  def limpar_redefinicao_senha_token!
    update!(redefinicao_senha_token: nil, redefinicao_senha_sent_at: nil)
  end

  # Remove o token de definição de senha e a data de envio do banco de dados.
  #
  # @return [void]
  # @note Define +definicao_senha_token+ e +definicao_senha_sent_at+ como +nil+.
  def limpar_definicao_senha_token!
    update!(definicao_senha_token: nil, definicao_senha_sent_at: nil)
  end

  private

  # Valida a confirmação e o tamanho mínimo da senha.
  #
  # @return [void]
  # @note Adiciona erros em +:senha+ se a confirmação não conferir ou se a senha tiver
  #   menos de 6 caracteres.
  def validar_senha
    if senha_confirmation.present? && senha != senha_confirmation
      errors.add(:senha, :confirmation, message: "confirmação não confere")
    end

    if senha.length < 6
      errors.add(:senha, :invalid, message: "senha inválida")
    end
  end

  # Gera e armazena o hash BCrypt da senha antes de salvar o registro.
  #
  # @return [void]
  # @note Atualiza o campo virtual +senha_hash+ com o resultado de +BCrypt::Password.create+.
  def atualizar_senha_hash
    self.senha_hash = BCrypt::Password.create(senha)
  end
end
