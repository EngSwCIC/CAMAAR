##
# Define a associação entre o modelo Resposta e os modelos User, Questao e Formulario.
#
# == Associações
# - Uma Resposta pertence a um User.
# - Uma Resposta pertence a uma Questao.
# - Uma Resposta pertence a um Formulario.
#
# +effect_side+ Configura as relações de dados entre Resposta e os modelos User, Questao e Formulario. 
class Resposta < ApplicationRecord
    belongs_to :user
    belongs_to :questao
    belongs_to :formulario
end
