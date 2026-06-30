class Admin < ApplicationRecord
  belongs_to :usuario
  belongs_to :departamento
end
