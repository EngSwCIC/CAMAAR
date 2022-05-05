class SelectedOption < ApplicationRecord
  belongs_to :option, optional: { scope: :custom_option }
  belongs_to :answer

  validates :custom_option, presence: true, unless: :option
end
