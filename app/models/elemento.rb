class Elemento < ApplicationRecord
  belongs_to :template
  has_many :campos, dependent: :destroy
  accepts_nested_attributes_for :campos, allow_destroy: true
end
