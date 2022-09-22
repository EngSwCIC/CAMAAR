class Enrollment < ApplicationRecord
    belongs_to :cclass
    belongs_to :member
    
    validates :grade, numericality: {in: 0..100}, allow_nil: true
end
