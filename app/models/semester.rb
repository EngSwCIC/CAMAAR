class Semester < ApplicationRecord
   belongs_to :template
   validates :half, uniqueness: { scope: :year}
end
