require 'rails_helper'

RSpec.describe Materium, type: :model do
  describe 'validations' do

    context 'is valid with valid attributes' do
      it 'should be valid with valid attributes' do
        create(:departamento, id: 1, nome: "CIC")
        materium = build(:materium, departamento_id:1)
        expect(materium).to be_valid
      end
    end

    context 'is not valid without a nome' do
        it 'should be invalid without nome' do
          materium = build(:materium, nome: nil, departamento_id:1)
          expect(materium).not_to be_valid
        end
      end

    context 'is not valid without a codigo' do
        it 'should be invalid without codigo' do
          materium = build(:materium, codigo: nil, departamento_id:1)
          expect(materium).not_to be_valid
        end
      end

      context 'is not valid without a semestre' do
        it 'should be invalid without semestre' do
          materium = build(:materium, semestre: nil, departamento_id:1)
          expect(materium).not_to be_valid
        end
      end

      context 'is not valid without a horario' do
        it 'should be invalid without horario' do
          materium = build(:materium, horario: nil, departamento_id:1)
          expect(materium).not_to be_valid
        end
      end

      context 'is not valid without a departamento_id' do
        it 'should be invalid without departamento_id' do
          materium = build(:materium, departamento_id: nil)
          expect(materium).not_to be_valid
        end
      end

  end

  describe 'retrieving data from SIGAA' do
    context 'when calling the method get_data_from_SIGAA' do
      it 'calls the SIGAA API wrapper' do
        @sigaa_data = File.read('classes.json')

        expect(SIGAA::Client).to receive(:fetch_classes)
        Materium.get_sigaa_classes
      end
    end

    context 'when te class informed does not exist' do
      it 'raises an "NotFoundError"' do
        allow(SIGAA::Client).to receive(:find_class).and_raise(SIGAA::Client::NotFound)
        expect {Materium.get_sigaa_classes}.to raise_error(Materium::NotFound)
      end
    end
  end
end
