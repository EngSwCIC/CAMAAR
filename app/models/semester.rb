class Semester < ApplicationRecord
  def self.next_semester_id
    latest_semester = self.order(id: :desc).first

    if latest_semester.nil?
      half = 0
      year = 2020
    else
      if latest_semester.half
        half = 0
        year = latest_semester.year + 1
      else
        half = 1
        year = latest_semester.year
      end
    end
    new_semester = self.create(half: half, year: year)
    return new_semester.id
  end

  def self.current_semester
    latest_semester = self.order(id: :desc).first
    if latest_semester 
      if latest_semester.half
        half = 2
      else
        half = 1
      end
        "#{latest_semester.year}.#{half}."
    else
      "Sem semestre cadastrado."
    end
  end

  def self.current_semester_id
    latest_semester = self.order(id: :desc).first
    if latest_semester
      return latest_semester.id
    else
      return latest_semester
    end
  end
end
