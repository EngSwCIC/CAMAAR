class Alternativa < ApplicationRecord
  belongs_to :questaos

  validates :texto, presence: true
end
