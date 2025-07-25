##
# Representa um usuário do sistema CAMAAR (Sistema de Avaliação de Atividades Acadêmicas Remotas)
#
# Um usuário pode ter três tipos de ocupação:
# * +admin+: Administrador do sistema, pode criar e gerenciar templates de avaliação
# * +docente+: Professor, pode responder avaliações e ter acesso a funcionalidades específicas
# * +discente+: Aluno, pode responder avaliações disponibilizadas pelos administradores
#
# === Autenticação
#
# Utiliza +has_secure_password+ do Rails para criptografia segura de senhas.
# Suporta login tanto por email quanto por matrícula (apenas para discentes).
#
# === Exemplo de uso
#
#   # Criar um aluno
#   aluno = User.create!(
#     nome: "João Silva",
#     email: "joao@aluno.unb.br",
#     matricula: "123456789",
#     password: "senha123",
#     password_confirmation: "senha123",
#     ocupacao: "discente"
#   )
#
#   # Criar um administrador
#   admin = User.create!(
#     nome: "Maria Admin",
#     email: "maria@admin.unb.br",
#     password: "admin123",
#     password_confirmation: "admin123",
#     ocupacao: "admin"
#   )
#
#   # Verificar tipo de usuário
#   aluno.discente?  # => true
#   admin.admin?     # => true
#
#   # Autenticar usuário
#   User.authenticate("joao@aluno.unb.br", "senha123")  # => User object
#   User.authenticate("123456789", "senha123")          # => User object (por matrícula)
#
class User < ApplicationRecord
  has_secure_password

  ##
  # Tempo de expiração para tokens de reset de senha (2 horas)
  RESET_TOKEN_EXPIRATION = 2.hours

  ##
  # Custo de processamento para digest de senhas
  # Maior em produção para mais segurança, menor em desenvolvimento para velocidade
  DIGEST_COST = Rails.env.production? ? 12 : 1

  ##
  # Tipos de ocupação válidos no sistema
  ROLES = %w[admin docente discente].freeze

  # Associações
  ##
  # Templates criados pelo usuário (apenas admins podem criar)
  has_many :templates, dependent: :destroy

  ##
  # Respostas do usuário aos templates disponíveis
  has_many :template_responses, dependent: :destroy

  # Validações
  validates :ocupacao, inclusion: { in: ROLES }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :matricula, uniqueness: true, allow_nil: true
  validate :matricula_required_unless_admin_or_docente

  ##
  # Gera um token seguro para reset de senha
  #
  # Cria um token único e define o timestamp de envio para controle de expiração.
  # O token é armazenado como digest para segurança.
  #
  # === Retorno
  # +String+:: Token em texto plano (deve ser enviado por email)
  #
  # === Exemplo
  #   user = User.find_by(email: "usuario@exemplo.com")
  #   token = user.generate_password_reset_token!
  #   UserMailer.password_reset(user, token).deliver_now
  def generate_password_reset_token!
    raw_token = SecureRandom.urlsafe_base64(20)
    digest = generate_digest(raw_token)
    update_columns(
      password_reset_token: digest,
      password_reset_sent_at: Time.zone.now
    )
    raw_token
  end

  ##
  # Verifica se o token de reset de senha é válido
  #
  # Valida tanto a autenticidade do token quanto sua expiração temporal.
  #
  # === Parâmetros
  # +raw_token+:: Token em texto plano para verificação
  #
  # === Retorno
  # +Boolean+:: true se o token é válido e não expirado
  #
  # === Exemplo
  #   if user.password_reset_token_valid?(params[:token])
  #     # Permitir reset de senha
  #   else
  #     # Token inválido ou expirado
  #   end
  def password_reset_token_valid?(raw_token)
    return false unless password_reset_token.present? &&
                        password_reset_sent_at.present? &&
                        raw_token.present?

    authenticated?(:password_reset, raw_token) &&
      password_reset_sent_at >= RESET_TOKEN_EXPIRATION.ago
  end

  ##
  # Limpa os dados de reset de senha
  #
  # Remove o token e timestamp após uso bem-sucedido ou expiração.
  #
  # === Exemplo
  #   if user.update(password: new_password)
  #     user.clear_password_reset_token!
  #   end
  def clear_password_reset_token!
    update_columns(
      password_reset_token: nil,
      password_reset_sent_at: nil
    )
  end

  ##
  # Autentica usuário por email ou matrícula
  #
  # Permite login flexível usando email (todos os tipos) ou matrícula (apenas discentes).
  #
  # === Parâmetros
  # +login+:: Email ou matrícula do usuário
  # +password+:: Senha em texto plano
  #
  # === Retorno
  # +User+:: Usuário autenticado ou nil se falhou
  #
  # === Exemplo
  #   # Por email
  #   user = User.authenticate("joao@aluno.unb.br", "senha123")
  #
  #   # Por matrícula (apenas discentes)
  #   user = User.authenticate("123456789", "senha123")
  def self.authenticate(login, password)
    user = find_by(email: login) || find_by(matricula: login)
    user&.authenticate(password)
  end

  ##
  # Gera e armazena token para funcionalidade "Lembrar-me"
  #
  # Cria um token de sessão persistente para login automático.
  #
  # === Retorno
  # +String+:: Token para armazenar em cookie
  #
  # === Exemplo
  #   if params[:remember_me] == '1'
  #     remember_token = user.remember
  #     cookies.permanent[:remember_token] = remember_token
  #   end
  def remember
    self.remember_token = SecureRandom.urlsafe_base64
    update_column(:remember_digest, generate_digest(remember_token))
    remember_token
  end

  ##
  # Remove token de "Lembrar-me"
  #
  # Limpa o digest armazenado, invalidando tokens existentes.
  def forget
    update_column(:remember_digest, nil)
  end

  ##
  # Verifica autenticidade de tokens diversos
  #
  # Método genérico para validar diferentes tipos de tokens (remember, password_reset, etc.)
  # usando comparação segura contra timing attacks.
  #
  # === Parâmetros
  # +attribute+:: Tipo do token (:remember, :password_reset)
  # +token+:: Token em texto plano para verificação
  #
  # === Retorno
  # +Boolean+:: true se o token é válido
  #
  # === Exemplo
  #   user.authenticated?(:remember, cookies[:remember_token])
  #   user.authenticated?(:password_reset, params[:token])
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil? || token.nil?

    # Prevenção contra timing attacks
    ActiveSupport::SecurityUtils.secure_compare(
      ::BCrypt::Password.new(digest).to_s,
      ::BCrypt::Engine.hash_secret(token, digest)
    )
  end

  ##
  # Verifica se o usuário é administrador
  #
  # === Retorno
  # +Boolean+:: true se ocupacao == 'admin'
  #
  # === Exemplo
  #   if current_user.admin?
  #     # Mostrar funcionalidades de administração
  #   end
  def admin?
    ocupacao == "admin"
  end

  ##
  # Verifica se o usuário é docente
  #
  # === Retorno
  # +Boolean+:: true se ocupacao == 'docente'
  #
  # === Exemplo
  #   if current_user.docente?
  #     # Funcionalidades específicas para professores
  #   end
  def docente?
    ocupacao == "docente"
  end

  ##
  # Verifica se o usuário é discente (aluno)
  #
  # === Retorno
  # +Boolean+:: true se ocupacao == 'discente'
  #
  # === Exemplo
  #   if current_user.discente?
  #     # Funcionalidades específicas para alunos
  #   end
  def discente?
    ocupacao == "discente"
  end

  private

  ##
  # Gera digest BCrypt para tokens
  #
  # === Parâmetros
  # +token+:: Token em texto plano
  #
  # === Retorno
  # +String+:: Hash BCrypt do token
  def generate_digest(token)
    cost = DIGEST_COST
    BCrypt::Password.create(token, cost: cost)
  end

  ##
  # Validação customizada para matrícula obrigatória em discentes
  #
  # Discentes devem ter matrícula preenchida, enquanto admins e docentes não precisam.
  def matricula_required_unless_admin_or_docente
    if discente? && matricula.blank?
      errors.add(:matricula, "é obrigatória para discentes")
    end
  end
end
