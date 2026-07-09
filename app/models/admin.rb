class Admin < ApplicationRecord
  belongs_to :user
  belongs_to :departamento

  validates :user_id, uniqueness: { scope: :departamento_id }
end
