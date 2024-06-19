require 'rails_helper'

RSpec.describe Semester, type: :model do
  describe '.next_semester_id' do
    context 'when no semesters exist' do
      it 'creates a new semester starting from year 2020 and half 0' do
        expect {
          Semester.next_semester_id
        }.to change(Semester, :count).by(1)

        new_semester = Semester.last
        expect(new_semester.year).to eq(2020)
        expect(new_semester.half).to eq(false)
      end
    end

    context 'when latest semester is in half' do
      before do
        Semester.create(year: 2023, half: 1)
      end

      it 'creates a new semester in the next year' do
        expect {
          Semester.next_semester_id
        }.to change(Semester, :count).by(1)

        new_semester = Semester.last
        expect(new_semester.year).to eq(2024)
        expect(new_semester.half).to eq(false)
      end
    end

    context 'when latest semester is not half' do
      before do
        Semester.create(year: 2023, half: 0)
      end

      it 'creates a new semester in the same year that is half' do
        expect {
          Semester.next_semester_id
        }.to change(Semester, :count).by(1)

        new_semester = Semester.last
        expect(new_semester.year).to eq(2023)
        expect(new_semester.half).to eq(true)
      end
    end
  end

  describe '.current_semester' do
    context 'when there are semesters' do
      it 'returns the formatted current semester' do
        Semester.create(year: 2023, half: 1)

        expect(Semester.current_semester).to eq("2023.2.")
      end
    end

    context 'when there are no semesters' do
      it 'returns a message indicating no semester is registered' do
        expect(Semester.current_semester).to eq("Sem semestre cadastrado.")
      end
    end
  end

  describe '.current_semester_id' do
    context 'when there are semesters' do
      it 'returns the ID of the latest semester' do
        semester = Semester.create(year: 2023, half: 1)

        expect(Semester.current_semester_id).to eq(semester.id)
      end
    end

    context 'when there are no semesters' do
      it 'returns nil' do
        expect(Semester.current_semester_id).to be_nil
      end
    end
  end
end
