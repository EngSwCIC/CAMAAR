class Template < ApplicationRecord
  has_many :template_question, dependent: :destroy
end
