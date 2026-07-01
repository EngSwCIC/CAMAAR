# Modelo de Usuário do sistema
class User < ApplicationRecord
  has_secure_password validations: false

  has_many :turma_memberships, dependent: :destroy
  has_many :turmas, through: :turma_memberships
  has_many :form_responses, dependent: :destroy

  validates :email, uniqueness: true, allow_blank: false
  validates :matricula, uniqueness: true, allow_blank: false
  validates :role, inclusion: { in: %w[admin discente docente] }
  validates :password, length: { minimum: 8 }, if: :password_being_set?
  validates :password, confirmation: true,      if: :password_being_set?

  # Busca um usuário pelo email ou matricula
  #
  # Argumentos: login (String)
  # Retorno: User ou nil
  # Efeitos Colaterais: Busca no BD
  def self.find_by_login(login)
    find_by(email: login) || find_by(matricula: login)
  end

  # Verifica se é admin
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Nenhum
  def admin?
    role == "admin"
  end

  # Verifica se é discente
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Nenhum
  def discente?
    role == "discente"
  end

  # Verifica se é docente
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Nenhum
  def docente?
    role == "docente"
  end

  # Retorna o perfil vinculado (Discente ou Docente)
  #
  # Argumentos: Nenhum
  # Retorno: Collection
  # Efeitos Colaterais: Consulta no BD
  def profile
    @profile ||= if discente?
                   Discente.where(matricula: matricula)
                 elsif docente?
                   Docente.where(usuario: matricula)
                 end
  end

  # Retorna turmas vinculadas ao usuário via importação SIGAA (legado)
  #
  # Argumentos: Nenhum
  # Retorno: ActiveRecord::Relation ou Array vazio
  # Efeitos Colaterais: Consulta no BD
  def sigaa_turmas
    if discente?
      Turma.where(id: Discente.where(matricula: matricula).select(:turma_id))
    elsif docente?
      Turma.where(id: Docente.where(usuario: matricula).select(:turma_id))
    else
      Turma.none
    end
  end

  # Gera token de convite e salva
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Modifica BD
  def generate_invitation_token!
    self.invitation_token   = SecureRandom.urlsafe_base64(32)
    self.invitation_sent_at = Time.current
    save!(validate: false)
  end

  # Checa se o convite expirou (24h)
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Nenhum
  def invitation_token_expired?
    invitation_sent_at.nil? || invitation_sent_at < 24.hours.ago
  end

  # Consome token de convite
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Atualiza colunas no BD
  def consume_invitation_token!
    update_columns(invitation_token: nil, invitation_sent_at: nil)
  end

  # Gera token de redefinição de senha
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Modifica BD
  def generate_reset_token!
    self.reset_token   = SecureRandom.urlsafe_base64(32)
    self.reset_sent_at = Time.current
    save!(validate: false)
  end

  # Checa se o token de senha expirou (24h)
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Nenhum
  def reset_token_expired?
    reset_sent_at.nil? || reset_sent_at < 24.hours.ago
  end

  # Consome token de redefinição
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Atualiza colunas no BD
  def consume_reset_token!
    update_columns(reset_token: nil, reset_sent_at: nil)
  end

  private

  # Verifica se a senha está sendo cadastrada
  #
  # Argumentos: Nenhum
  # Retorno: Booleano
  # Efeitos Colaterais: Nenhum
  def password_being_set?
    password.present? || password_confirmation.present?
  end
end