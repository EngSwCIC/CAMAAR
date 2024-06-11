class Question < ApplicationRecord
  belongs_to :template
  validates :text, presence: true
end
