class FormRequest < ApplicationRecord
  belongs_to :study_class
  belongs_to :user
  belongs_to :template
end
