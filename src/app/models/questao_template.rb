##
# Define a associação entre o modelo QuestaoTemplate e outros modelos.
#
# == Associações
# - Um QuestaoTemplate pertence a uma Questao e a um Template.
#
# +effect_side+ Define as associações de dados entre QuestaoTemplate e os modelos Questao e Template.
class QuestaoTemplate < ApplicationRecord
  belongs_to :questao
  belongs_to :template
end
