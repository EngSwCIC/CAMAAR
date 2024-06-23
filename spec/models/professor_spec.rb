require 'rails_helper'

require 'simplecov'
SimpleCov.start

RSpec.describe Professor, type: :model do
  describe '.create_by_json' do
    let(:docente_data) { { "name" => "John Doe", "department_code" => "COMP", "registration" => "12345" } }

    context 'when professor does not exist' do
      it 'creates a new professor' do
        expect {
          Professor.create_by_json(docente_data)
        }.to change(Professor, :count).by(1)

        created_professor = Professor.last
        expect(created_professor.name).to eq("John Doe")
        expect(created_professor.department_code).to eq("COMP")
        expect(created_professor.registration_number).to eq("12345")
      end
    end

    context 'when professor already exists' do
      before do
        Professor.create!(name: "Jane Smith", department_code: "MATH", registration_number: "12345")
      end

      it 'does not create a new professor' do
        expect {
          Professor.create_by_json(docente_data)
        }.not_to change(Professor, :count)
      end
    end
  end
end
