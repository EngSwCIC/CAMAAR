class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :registrable, :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  validates_format_of :matricula, with: /[0-9]*/

  attr_writer :login

  has_and_belongs_to_many :study_classes
  has_many :form_requests

  def login
    @login || self.matricula || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions.to_h).where(["matricula = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:matricula) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def find_pending_forms
    FormRequest.where(user_id: self.id, answered: false)
  end

  # para permitir a criacao de usuarios sem preencher o campo de senha
  attr_accessor :skip_password_validation

  protected

  def password_required?
    return false if skip_password_validation
    super
  end
end
