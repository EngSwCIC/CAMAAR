class Template < ApplicationRecord
  has_many :questions, dependent: :destroy
  accepts_nested_attributes_for :questions, reject_if: :all_blank, allow_destroy: true

  validates :title, presence: true
  validates :questions, presence: true
end
