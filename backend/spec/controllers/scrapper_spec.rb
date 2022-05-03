require 'rails_helper'


RSpec.describe ScrapperController, :type => :controller do

    context 'method show' do

        it 'should render all the classes' do

            turmas = %Q{{
                    "classes": [
                      {
                        "code": "CIC0097",
                        "name": "BANCOS DE DADOS",
                        "class": {
                          "classCode": "TA",
                          "semester": "2021.2",
                          "time": "35T45"
                        }
                      },
                      {
                        "code": "CIC0105",
                        "name": "ENGENHARIA DE SOFTWARE",
                        "class": {
                          "classCode": "TA",
                          "semester": "2021.2",
                          "time": "35M12"
                        }
                      },
                      {
                        "code": "CIC0202",
                        "name": "PROGRAMAÇÃO CONCORRENTE",
                        "class": {
                          "classCode": "TA",
                          "semester": "2021.2",
                          "time": "35M34"
                        }
                      }
                    ]
                  }}

            # Stub (hard code)
            allow(Api::SearchClasses).to receive(:call) do
                turmas
            end
            
            get :show
            expect(response).to have_http_status(200)
            expect(response.body).to eq("{\"classes\":{\"classes\":[{\"code\":\"CIC0097\",\"name\":\"BANCOS DE DADOS\",\"class\":{\"classCode\":\"TA\",\"semester\":\"2021.2\",\"time\":\"35T45\"}},{\"code\":\"CIC0105\",\"name\":\"ENGENHARIA DE SOFTWARE\",\"class\":{\"classCode\":\"TA\",\"semester\":\"2021.2\",\"time\":\"35M12\"}},{\"code\":\"CIC0202\",\"name\":\"PROGRAMAÇÃO CONCORRENTE\",\"class\":{\"classCode\":\"TA\",\"semester\":\"2021.2\",\"time\":\"35M34\"}}]}}")
        end


    end

end