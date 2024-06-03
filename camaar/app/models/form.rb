class Form < ApplicationRecord
  belongs_to :template, optional: true
  belongs_to :coordinator
  belongs_to :subject_class
end
