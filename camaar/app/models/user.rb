class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  validates :nome, presence: true
  validates :email, presence: true
  :curso
  validates :matricula, presence: true
  validates :formacao, presence: true
  validates :ocupacao, presence: true
  validates :password, presence: true
  # validates :password_confirmation, presence: true


  has_many :matriculas
  has_many :turmas, through: :matriculas

  # Add the role attribute (replace with your desired role types)
  enum role: [:admin, :user]  # This defines roles as 'admin' or 'user'
  after_initialize :set_default_role, :if => :new_record?
  def set_default_role
    self.role ||= :user
  end
end
