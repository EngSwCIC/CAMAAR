class SelectedOption < ApplicationRecord
  belongs_to :option
  belongs_to :answer

  validates :custom_option, presence: true

end
