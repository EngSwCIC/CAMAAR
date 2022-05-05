class SelectedOption < ApplicationRecord
  belongs_to :option, optional: true
  belongs_to :answer

  validates :custom_option, presence: true, unless: :option
end
