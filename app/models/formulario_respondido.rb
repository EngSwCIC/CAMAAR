class FormularioRespondido < ApplicationRecord
  belongs_to :pessoa, foreign_key: 'email'
  belongs_to :formulario
end
