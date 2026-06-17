class RespostaElem < ApplicationRecord
  belongs_to :resposta_form
  belongs_to :elemento_form
  belongs_to :campo_form, optional: true
  validates :texto_resposta, presence: true
end
