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

  describe 'extractClass' do

    before(:each) do
      file_url = "file://#{Dir.pwd}/spec/services/web-pages/participantes_turma.html"
      turma = {"codigo" => 'CIC105',
               "turma" => "T02" }

      browser = Watir::Browser.new :chrome, headless: true
      browser.goto file_url

      @turma_info = @extractor.extractClass( turma, browser)
    end

    it 'should return a hash containing of the right format' do
      

      expect(@turma_info).to be_an(Hash)
      expect(@turma_info).to have_key(:code)
      expect(@turma_info).to have_key(:classCode)
      expect(@turma_info).to have_key(:docente)
      expect(@turma_info[:docente]).to be_an(Hash)
      expect(@turma_info[:docente]).to be_an(Hash)
      expect(@turma_info).to have_key(:dicente)
      expect(@turma_info[:dicente]).to be_an(Array)
      
    end


  end
end
