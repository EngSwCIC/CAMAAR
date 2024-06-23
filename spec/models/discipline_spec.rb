require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe Discipline, type: :model do
  describe '.create_by_json' do
    let(:data) { { "name" => "Math", "code" => "MTH101", "professor_registration" => "12345" } }
    let(:semester_id) { 1 }

    it 'creates a new discipline with valid data' do
      discipline = Discipline.create_by_json(data, semester_id)

      expect(discipline.name).to eq("Math")
      expect(discipline.code).to eq("MTH101")
      expect(discipline.professor_registration).to eq("12345")
      expect(discipline.semester_id).to eq(semester_id)
    end   
  end
end
