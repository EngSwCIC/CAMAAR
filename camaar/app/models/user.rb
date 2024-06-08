class User < ApplicationRecord
  has_many :matriculas
  has_many :turmas, through: :matriculas
end
