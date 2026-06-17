class User < ApplicationRecord
  has_secure_password validations: false

  has_many :respostas, dependent: :destroy

  validates :email, uniqueness: true, allow_blank: false
  validates :matricula, uniqueness: true, allow_blank: false
  validates :role, inclusion: { in: %w[admin discente docente] }
  validates :password, length: { minimum: 8 }, if: :password_being_set?
  validates :password, confirmation: true,      if: :password_being_set?

  def self.find_by_login(login)
    find_by(email: login) || find_by(matricula: login)
  end

  def admin?
    role == "admin"
  end

  def discente?
    role == "discente"
  end

  def docente?
    role == "docente"
  end

  def profile
    @profile ||= if discente?
                   Discente.where(matricula: matricula)
                 elsif docente?
                   Docente.where(usuario: matricula)
                 end
  end

  def turmas
    if discente?
      Turma.where(id: Discente.where(matricula: matricula).select(:turma_id))
    elsif docente?
      Turma.where(id: Docente.where(usuario: matricula).select(:turma_id))
    else
      []
    end
  end

  def generate_invitation_token!
    self.invitation_token   = SecureRandom.urlsafe_base64(32)
    self.invitation_sent_at = Time.current
    save!(validate: false)
  end

  def invitation_token_expired?
    invitation_sent_at.nil? || invitation_sent_at < 24.hours.ago
  end

  def consume_invitation_token!
    update_columns(invitation_token: nil, invitation_sent_at: nil)
  end

  def generate_reset_token!
    self.reset_token   = SecureRandom.urlsafe_base64(32)
    self.reset_sent_at = Time.current
    save!(validate: false)
  end

  def reset_token_expired?
    reset_sent_at.nil? || reset_sent_at < 24.hours.ago
  end

  def consume_reset_token!
    update_columns(reset_token: nil, reset_sent_at: nil)
  end

  private

  def password_being_set?
    password.present? || password_confirmation.present?
  end
end