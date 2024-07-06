##
# Define a associação entre o modelo Formulario e outros modelos.
#
# == Associações
# - Um Formulário pertence a um Template e a uma Turma.
# - Um Formulário pode ter muitas Respostas associadas a ele.
#
# +effect_side+ Define as associações de dados entre Formulário e outros modelos.
class Formulario < ApplicationRecord
    belongs_to :template
    belongs_to :turma
    has_many :respostas
end
