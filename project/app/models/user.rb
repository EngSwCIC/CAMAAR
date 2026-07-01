##
# Representa administradores e participantes autenticáveis do CAMAAR. Também
# administra os tokens temporários usados nos fluxos de senha.
class User < ApplicationRecord
  # Período durante o qual o link de definição da primeira senha permanece válido.
  PASSWORD_SETUP_TTL = 7.days
  # Período durante o qual o link de redefinição de senha permanece válido.
  PASSWORD_RESET_TTL = 2.hours

  belongs_to :department, optional: true
  has_many :class_memberships, dependent: :destroy
  has_many :course_classes, through: :class_memberships
  has_many :templates, foreign_key: :admin_id, dependent: :destroy
  has_many :formularios, foreign_key: :admin_id, dependent: :destroy

  has_secure_password validations: false

  enum :role, { admin: 0, participant: 1 }

  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :registration, with: ->(registration) { registration.strip }

  validates :name, :email, :registration, :role, presence: true
  validates :email, uniqueness: true
  validates :registration, uniqueness: true

  ##
  # Localiza um usuário por e-mail ou matrícula para autenticação.
  #
  # === Argumentos
  #
  # +identifier+:: E-mail ou matrícula informada no login.
  #
  # === Retorno
  #
  # Retorna o User encontrado ou +nil+ quando não há correspondência.
  #
  # === Efeitos colaterais
  #
  # Consulta o banco de dados.
  def self.find_for_login(identifier)
    normalized = identifier.to_s.strip
    find_by(email: normalized.downcase) || find_by(registration: normalized)
  end

  ##
  # Localiza o usuário de um token válido de definição inicial de senha.
  #
  # === Argumentos
  #
  # +token+:: Token em texto puro recebido pelo usuário.
  #
  # === Retorno
  #
  # Retorna o User correspondente ou +nil+ quando o token é inexistente ou expirou.
  #
  # === Efeitos colaterais
  #
  # Consulta o banco de dados.
  def self.find_by_setup_token(token)
    find_valid_token(:password_setup_token_digest, :password_setup_sent_at, token, PASSWORD_SETUP_TTL)
  end

  ##
  # Localiza o usuário de um token válido de redefinição de senha.
  #
  # === Argumentos
  #
  # +token+:: Token em texto puro recebido pelo usuário.
  #
  # === Retorno
  #
  # Retorna o User correspondente ou +nil+ quando o token é inexistente ou expirou.
  #
  # === Efeitos colaterais
  #
  # Consulta o banco de dados.
  def self.find_by_reset_token(token)
    find_valid_token(:password_reset_token_digest, :password_reset_sent_at, token, PASSWORD_RESET_TTL)
  end

  ##
  # Informa se o usuário já possui uma senha armazenada.
  #
  # Não recebe argumentos.
  #
  # Retorna +true+ quando +password_digest+ está preenchido e +false+ caso contrário.
  #
  # Efeitos colaterais: não possui efeitos colaterais.
  def password_defined?
    password_digest.present?
  end

  ##
  # Informa se o usuário ainda precisa definir sua primeira senha.
  #
  # Não recebe argumentos.
  #
  # Retorna +true+ quando não há senha definida e +false+ caso contrário.
  #
  # Efeitos colaterais: não possui efeitos colaterais.
  def pending_password_setup?
    !password_defined?
  end

  ##
  # Gera e persiste um token temporário para definição da primeira senha.
  #
  # Não recebe argumentos.
  #
  # Retorna o token em texto puro que deve ser enviado ao usuário.
  #
  # Efeitos colaterais: atualiza o digest e o horário do token no banco e pode lançar
  # ActiveRecord::RecordInvalid quando a persistência falha.
  def generate_password_setup_token!
    token = SecureRandom.urlsafe_base64(32)
    update!(password_setup_token_digest: self.class.token_digest(token), password_setup_sent_at: Time.current)
    token
  end

  ##
  # Gera e persiste um token temporário para redefinição de senha.
  #
  # Não recebe argumentos.
  #
  # Retorna o token em texto puro que deve ser enviado ao usuário.
  #
  # Efeitos colaterais: atualiza o digest e o horário do token no banco e pode lançar
  # ActiveRecord::RecordInvalid quando a persistência falha.
  def generate_password_reset_token!
    token = SecureRandom.urlsafe_base64(32)
    update!(password_reset_token_digest: self.class.token_digest(token), password_reset_sent_at: Time.current)
    token
  end

  ##
  # Substitui a senha do usuário e invalida todos os tokens de senha existentes.
  #
  # === Argumentos
  #
  # +new_password+:: Nova senha em texto puro que será processada por +has_secure_password+.
  #
  # === Retorno
  #
  # Retorna +true+ quando a atualização é concluída.
  #
  # === Efeitos colaterais
  #
  # Atualiza a senha e limpa os tokens no banco; pode lançar ActiveRecord::RecordInvalid.
  def apply_new_password!(new_password)
    update!(
      password: new_password,
      password_setup_token_digest: nil,
      password_setup_sent_at: nil,
      password_reset_token_digest: nil,
      password_reset_sent_at: nil
    )
  end

  ##
  # Calcula o digest SHA-256 usado para armazenar tokens sem guardar o texto puro.
  #
  # === Argumentos
  #
  # +token+:: Valor que será convertido para String e processado.
  #
  # === Retorno
  #
  # Retorna uma String hexadecimal com o digest SHA-256.
  #
  # === Efeitos colaterais
  #
  # Não possui efeitos colaterais.
  def self.token_digest(token)
    Digest::SHA256.hexdigest(token.to_s)
  end

  ##
  # Localiza um usuário por digest e confirma se o token ainda está dentro do prazo.
  #
  # === Argumentos
  #
  # +digest_column+:: Nome da coluna que armazena o digest do token.
  # +sent_at_column+:: Nome da coluna que registra quando o token foi criado.
  # +token+:: Token em texto puro usado na busca.
  # +ttl+:: Duração máxima de validade do token.
  #
  # === Retorno
  #
  # Retorna o User associado ou +nil+ quando não existe registro, data de envio ou validade.
  #
  # === Efeitos colaterais
  #
  # Consulta o banco de dados.
  def self.find_valid_token(digest_column, sent_at_column, token, ttl)
    user = find_by(digest_column => token_digest(token))
    return unless user
    return if user.public_send(sent_at_column).blank?
    return if user.public_send(sent_at_column) < ttl.ago

    user
  end
  private_class_method :find_valid_token
end
