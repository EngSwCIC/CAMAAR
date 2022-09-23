require 'rails_helper'
#Aluno - Atila Araujo Lobo
#matricula  - 190103035
RSpec.describe "Subjects", type: :request do
  describe "GET /index" do
    #teste com objetivo de vericar qual dado seria encontrado no front
    #caso feita uma query especifica, pois foi feita de forma similar no front
    #para implementacao da feature
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
    # teste com o objetivo de verificar o resultado de uma query caso nao tenha
    # resultado para uma pesquisa
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
end
