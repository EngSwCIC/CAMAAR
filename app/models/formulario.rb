class Formulario < ApplicationRecord
  belongs_to :template
  belongs_to :turma
  belongs_to :coordenador
end
