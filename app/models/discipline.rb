class Discipline < ApplicationRecord
  def self.create_by_json(data, semester_id)
    create!(
      name: data["name"],
      code: data["code"],
      professor_registration: data["professor_registration"],
      semester_id: semester_id
    )
  end
end
