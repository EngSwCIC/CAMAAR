class Submissao < ApplicationRecord
  belongs_to :formulario
  belongs_to :user
end
