class Enrollment < ApplicationRecord
    belongs_to :cclass
    belongs_to :member
end
