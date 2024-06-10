class User < ApplicationRecord
  validates :nome, presence: true
  validates :email, presence: true
  validates :curso, presence: true
  validates :matricula, presence: true
  validates :formacao, presence: true
  validates :ocupacao, presence: true

  has_many :matriculas
  has_many :turmas, through: :matriculas
end
