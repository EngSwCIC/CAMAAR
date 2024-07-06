##
# Define a associação entre o modelo Questao e o modelo Template através da tabela de junção QuestaoTemplate.
#
# == Associações
# - Uma Questao pode estar associada a muitos Templates, e essa associação é intermediada pela tabela de junção QuestaoTemplate.
#
# +effect_side+ Configura as relações de dados entre Questao e Template usando a tabela de junção. 
class Questao < ApplicationRecord
    has_many :templates, through: :questoes_templates
end
