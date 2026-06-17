class CampoForm < ApplicationRecord
  belongs_to :elemento_form
  has_many :resposta_elems, dependent: :destroy
  validates :ordem, presence: true
end
