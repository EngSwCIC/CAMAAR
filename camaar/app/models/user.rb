class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, :trackable

  enum role: [:dicente, :docente]
  after_initialize :set_default_role, if: :new_record?

 def set_default_role
   self.role ||= :user
 end

  has_one :docente
  has_one :dicente

  validates :nome, presence: true
  validates :email, presence: true
  #validates :password, presence: true    ->teste
  validates :usuario, presence: true
  validates :formacao, presence: true
end
