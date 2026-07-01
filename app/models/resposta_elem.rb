# Representa a resposta de um usuário a um elemento (questão) específico do formulário.
#
# Pertence a uma +RespostaForm+ e ao +ElementoForm+ respondido. Para questões de
# múltipla escolha, também referencia o +CampoForm+ selecionado. Para questões de
# texto livre, +campo_form+ é opcional e o conteúdo fica em +texto_resposta+.
class RespostaElem < ApplicationRecord
  belongs_to :resposta_form
  belongs_to :elemento_form
  belongs_to :campo_form, optional: true
  validates :texto_resposta, presence: true
end
