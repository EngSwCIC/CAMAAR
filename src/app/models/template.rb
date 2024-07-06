##
# Define a associação entre o modelo Template e os modelos User, Formulario e Questao.
#
# == Associações
# - Um Template pertence a um User.
# - Um Template pode ter muitos Formularios.
# - Um Template pode ter muitas QuestaoTemplates.
# - Um Template pode ter muitas Questoes, através de QuestaoTemplates.
#
# +effect_side+ Configura as relações de dados entre Template e os modelos User, Formulario, Questao e QuestaoTemplate. 
class Template < ApplicationRecord
    belongs_to :user
    has_many :formularios

    has_many :questoes_templates
    has_many :questoes, through: :questoes_templates
end
