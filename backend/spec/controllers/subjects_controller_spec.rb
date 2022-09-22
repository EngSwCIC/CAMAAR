require 'rails_helper'

RSpec.describe SubjectsController, :type => :controller do
  context "GET #index" do
    #cenario de sucesso => verificando se conseguimos inserir os elementos corretamente no banco de dados.
    it "retorna a base dados na pagina" do
        allow(Subject).to receive(:all) do
            FactoryGirl.attributes_for(:subject)
        end
        get :index
        expect(response).to have_http_status(200)
        expect(response.body).to eq '{"value":[{"id":1,"code":"CIC0097","name":"BANCOS DE DADOS","created_at":"2022-09-08T14:06:01.511Z","updated_at":"2022-09-08T14:06:01.511Z"},{"id":2,"code":"CIC0105","name":"ENGENHARIA DE SOFTWARE","created_at":"2022-09-08T14:06:01.760Z","updated_at":"2022-09-08T14:06:01.760Z"},{"id":3,"code":"CIC0202","name":"PROGRAMAÇÃO CONCORRENTE","created_at":"2022-09-08T14:06:01.957Z","updated_at":"2022-09-08T14:06:01.957Z"}]}'

    end
    it "retorna o valor da pesquisa BANCOS com um caso com sucesso" do
        subjects = FactoryGirl.attributes_for(:subject)
        filterArg = "BANCOS"
        if (filterArg != "")
            subjects[:value] = subjects[:value].select{|v| v[:name][/#{filterArg}/]}
        end
        if (subjects[:value].length==0)
            subjects[:vaue] = [{'id': -1, 'code': 'AAA0000', 'name': 'pesquisa sem resultado', 'created_at': '0000-00-00T00:00:00.000Z', 'updated_at': '0000-00-00T00:00:00.000Z'}]
        end
        expect(subjects[:value][0][:name][/#{filterArg}/]).to eq filterArg
    end
    it "retorna o valor da pesquisa ABC com 'pesquisa sem resultado'" do
        subjects = FactoryGirl.attributes_for(:subject)
        filterArg = "ABC"
        if (filterArg != "")
            subjects[:value] = subjects[:value].select{|v| v[:name][/#{filterArg}/]}
        end

        if (subjects[:value].length==0)
            subjects[:value] = [{'id': -1, 'code': 'AAA0000', 'name': 'pesquisa sem resultado', 'created_at': '0000-00-00T00:00:00.000Z', 'updated_at': '0000-00-00T00:00:00.000Z'}]
        end
        expect(subjects[:value][0][:name]).to eq 'pesquisa sem resultado'
    end

  end
  it 'A controller mostra a pagina correta ao fazer busca' do
        allow(Subject).to receive(:find).and_return({"value":[{"id":1,"code":"CIC0097","name":"BANCOS DE DADOS","created_at":"2022-09-08T14:06:01.511Z","updated_at":"2022-09-08T14:06:01.511Z"}]})
        get :show, :params =>{:id => 1}
        expect(response).to have_http_status(200)
        expect(response.body).to eq '{"value":[{"id":1,"code":"CIC0097","name":"BANCOS DE DADOS","created_at":"2022-09-08T14:06:01.511Z","updated_at":"2022-09-08T14:06:01.511Z"}]}'
        #expect(response.body).not_to be nil
  end

end
