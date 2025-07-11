# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Enum para roles: 0 = admin, 1 = aluno, 2 = professor
  enum :role, { admin: 0, aluno: 1, professor: 2 }

  validates :name, presence: true
  validates :matricula, presence: true, uniqueness: true
  validates :role, presence: true

  before_save :downcase_email

  # Métodos para verificar roles
  def admin?
    role == 'admin'
  end

  def aluno?
    role == 'aluno'
  end

  def professor?
    role == 'professor'
  end

  # Permite que apenas admins cadastrem novos usuários
  def self.can_register?(current_user = nil)
    current_user&.admin?
  end

  private

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
