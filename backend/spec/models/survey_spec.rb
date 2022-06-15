require 'rails_helper'

RSpec.describe Survey, type: :model do

  describe '.validation' do

    context 'when all attributes is valid' do
      survey = Survey.new(name: 'test', description: 'test', semester: '2021/2', expiration_date: 2.hours.from_now)
      it 'should be valid' do
        expect(survey).to be_valid
      end
    end

    context 'when name is missing' do
      survey = Survey.new(description: 'test', semester: '2021/2', expiration_date: 2.hours.from_now)
      it 'should be invalid' do
        expect(survey).to be_invalid
      end
    end

    context 'when description is missing' do
      survey = Survey.new(name: 'test', semester: '2021/2', expiration_date: 2.hours.from_now)
      it 'should be invalid' do
        expect(survey).to be_invalid
      end
    end

    context 'when semester is missing' do
      survey = Survey.new(name: 'test', description: 'test', expiration_date: 2.hours.from_now)
      it 'should be invalid' do
        expect(survey).to be_invalid
      end
    end

    context 'when expiration_date is missing' do
      survey = Survey.new(name: 'test', description: 'test', semester: '2021/2')
      it 'should be invalid' do
        expect(survey).to be_invalid
      end
    end
    
  end

  describe '.is_expired?' do

    context 'when survey is expired' do
      survey = Survey.new(name: 'test', description: 'test', semester: '2021/2', expiration_date: 2.hours.ago)
      it 'should return true' do
        expect(survey.is_expired?).to eql true
      end
    end

    context 'when survey is not expired' do
      survey = Survey.new(name: 'test', description: 'test', semester: '2021/2', expiration_date: 2.hours.from_now)
      it 'should return false' do
        expect(survey.is_expired?).to eql false
      end
    end

  end

end
