require 'rails_helper'

describe MateriaController do
   describe 'retriving SIGAA existing classes' do
      it 'calls the model method that performs the SIGAA update' do
         @sigaa_data = File.read('classes.json')
         expect(Materium).to receive(:get_sigaa_classes).and_return(@sigaa_data)

         post :search_in_sigaa
      end
   end
end
