class Professor < ApplicationRecord
  def self.create_by_json(docente_data)
    registration_number = docente_data["registration"]

    unless Professor.exists?(registration_number: registration_number)
      create!(
        name: docente_data["name"],
        department_code: docente_data["department_code"],
        registration_number: registration_number
      )
    end
  end

  def self.find_by_registration(registration_number)
    find_by(registration_number: registration_number)
  end

end
