class Semester < ApplicationRecord
   has_many :templates
   validates :half, uniqueness: { scope: :year}
end
