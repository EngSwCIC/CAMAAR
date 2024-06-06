require 'rails_helper'

RSpec.describe Professor, type: :model do
  describe 'validations' do

    it 'is valid with valid attributes' do
      professor = build(:professor)
      expect(professor).to be_valid
    end

    it 'is not valid without a nome' do
      professor = build(:professor, nome: nil)
      expect(professor).not_to be_valid
    end


  end

  describe 'associations' do
    it { should belong_to(:departamento) }
    it { should have_many(:materias) }

  end

  describe 'methods' do
    it 'sets is_admin to true' do
      professor = create(:professor)
      professor.set_admin
      expect(professor.is_admin).to eq(true)
    end


  end
end

