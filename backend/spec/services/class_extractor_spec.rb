require 'rails_helper'

RSpec.describe SigaaManager::ClassExtractor, type: :model do
  before(:each) do
    @extractor = SigaaManager::ClassExtractor.new()
  end
  describe 'parseDocente' do

    it 'should generate a hash for a docente description' do


      text = "VANDER RAMOS ALVES\nDepartamento: DEPTO CIÊNCIAS DA COMPUTAÇÃO\nFormação: DOUTORADO\nUsuário: 19720169893\nE-Mail: valves@unb.br"

      expec_result = {
        :nome=>"VANDER RAMOS ALVES",
        :departamento=>"DEPTO CIÊNCIAS DA COMPUTAÇÃO",
        :formacao=>"DOUTORADO",
        :usuario=>"19720169893",
        :email=>"valves@unb.br",
        :ocupacao=>"docente",
      }
      expect(@extractor.parseDocente(text)).to eq(expec_result)
    end
  end

  describe 'parseDiscente' do
    it 'should generate a hash for a discente description' do

      text = "Victor Henrique do Rego Vieira de Sousa\nCurso: COMPUTAÇÃO/CIC\nMatrícula: 170157491\nUsuário: 170157491\nE-mail: victorhrvs@gmail.com"

      expec_result = {
        :nome=>"Victor Henrique do Rego Vieira de Sousa",
        :curso=>"COMPUTAÇÃO/CIC",
        :matricula=>"170157491",
        :usuario=>"170157491",
        :formacao=>"graduando",
        :ocupacao=>"dicente",
        :email=>"victorhrvs@gmail.com",
      }
      expect(@extractor.parseDiscente(text)).to eq(expec_result)

    end
  end

  describe 'call' do
    classes = JSON.parse('{"classes":[{"id":4,"nome":"PROGRAMAÇÃO CONCORRENTE","codigo":"CIC0202","turma":"T01","semestre":"2022.2","horario":"35M34"},{"id":5,"nome":"PROGRAMACAO FUNCIONAL","codigo":"CIC0133","turma":"T01","semestre":"2022.2","horario":"24M34"}]}')
    pending 'should return a json containing information about the parameter classes' 
  end
end
