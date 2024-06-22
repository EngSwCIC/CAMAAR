class Form < ApplicationRecord
  # belongs_to :template, optional: true
  belongs_to :coordinator
  belongs_to :subject_class
  has_many :form_question, dependent: :delete_all
end
