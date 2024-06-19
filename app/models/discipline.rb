class Discipline < ApplicationRecord
  has_many :form_disciplines
  has_many :forms, through: :form_disciplines

  def self.create_by_json(data, semester_id)
    create!(
      name: data['name'],
      code: data['code'],
      professor_registration: data['professor_registration'],
      semester_id:
    )
  end
end
