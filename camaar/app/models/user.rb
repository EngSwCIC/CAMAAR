class User < ApplicationRecord
  validates :nome, presence: true
  validates :senha, presence: true
end
