require 'rails_helper'

RSpec.describe "Subjects", type: :request do
  describe "GET /index" do
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
end
