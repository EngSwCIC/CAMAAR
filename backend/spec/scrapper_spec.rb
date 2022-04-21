require 'rails_helper'


RSpec.describe ScrapperController, :type => :controller do

    describe 'show' do

        before {get 'show'}

        it 'returns status code 200' do
            expect(response.status).to eq(200)
        end
    end

end