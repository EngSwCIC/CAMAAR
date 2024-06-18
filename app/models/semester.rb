class Semester < ApplicationRecord
  def self.next_semester_id
    latest_semester = self.order(id: :desc).first

    if latest_semester.nil?
      half = 1
      year = 2020
    else
      if latest_semester.half == 1
        half = 2
        year = latest_semester.year
      else
        half = 1
        year = latest_semester.year + 1
      end
    end
    new_semester = self.create(half: half, year: year)
    return new_semester.id
  end
end
