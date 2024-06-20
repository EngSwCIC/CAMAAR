class Template < ApplicationRecord
  has_many :form
  has_many :questions, as: :formlike

  def to_s
    "Modelo \##{self[:id]}"
  end
end
