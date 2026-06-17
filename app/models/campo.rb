class Campo < ApplicationRecord
  belongs_to :elemento
  validates :ordem, presence: true
  validates :ordem, uniqueness: { scope: :elemento_id }
  validates :tipo_elemento, presence: true
end
