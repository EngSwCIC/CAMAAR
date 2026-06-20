class Professor < ApplicationRecord
  belongs_to :usuario
  has_many :turmas
end
