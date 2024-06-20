require 'rails_helper'

describe MateriaController do
  describe 'retriving SIGAA existing classes' do
    it 'calls the model method that performs the SIGAA update' do
        @sigaa_data = JSON.parse(File.read("#{Rails.public_path}/classes.json"))
        expect(Materium).to receive(:get_sigaa_classes).and_return(@sigaa_data)

        post :search_in_sigaa
    end
  end

  describe 'updating SIGAA data to the database' do
    context 'when calling the method update_with_sigaa_data after fetching from SIGAA' do
      it 'updates the database' do
        @sigaa_classes = JSON.parse(File.read("#{Rails.public_path}/classes.json"))

        allow(Materium).to receive(:get_sigaa_classes).and_return(@sigaa_classes)

        expect(Materium).to receive(:find_by_codigo).with(@sigaa_classes[0]['code'])

        post :search_in_sigaa
        post :update_with_sigaa_data
      end
    end

    context 'when calling the method update_with_sigaa_data withoui having the latest SIGAA data' do
      it 'wont apply any changes to the original database' do
        expect(Materium).to_not receive(:find_by_codigo)

        post :update_with_sigaa_data
      end
    end
  end
end
