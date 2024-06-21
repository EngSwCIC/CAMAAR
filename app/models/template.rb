class Template < ApplicationRecord
  has_many :template_questions, dependent: :destroy
end
