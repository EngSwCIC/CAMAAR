# Representa um formulário de avaliação enviado a uma turma.
#
# É criado a partir de um +Template+ e associado a uma +Turma+. Contém os
# +ElementoForm+s (questões) que os usuários respondem, e agrega as
# +RespostaForm+s submetidas pelos participantes.
class Formulario < ApplicationRecord
  belongs_to :turma
  has_many :elemento_forms, dependent: :destroy
  has_many :resposta_forms, dependent: :destroy
end
