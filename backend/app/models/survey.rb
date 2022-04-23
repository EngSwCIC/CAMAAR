class Survey < ApplicationRecord
  has_many :questions
  belongs_to :cclass

end
