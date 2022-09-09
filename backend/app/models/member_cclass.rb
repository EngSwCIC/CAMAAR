class MemberCclass < ApplicationRecord
  belongs_to :member
  belongs_to :cclass
  validates :grade, numericality: {in: 0..100}, allow_nil: true

end
