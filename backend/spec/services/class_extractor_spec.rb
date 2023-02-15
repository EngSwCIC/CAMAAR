require 'yaml'
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

  describe 'extract_class' do

    before(:each) do
      file_url = "file://#{Dir.pwd}/spec/services/web-pages/participantes_turma.html"
      class_info = {}
      class_info["code"]  =  'CIC105'
      class_info["class"] = {"classCode"=> "T02" }

      browser = Watir::Browser.new :chrome, headless: true
      browser.goto file_url

      @turma_info = @extractor.extract_class(class_info, browser)
    end

    it 'should return a hash containing of the right format' do
      

      expect(@turma_info).to be_an(Hash)
      expect(@turma_info).to have_key(:code)
      expect(@turma_info).to have_key(:classCode)

      expect(@turma_info).to have_key(:docente)
      expect(@turma_info[:docente]).to be_an(Hash)
      expect(@turma_info[:docente]).to have_key(:nome)
      expect(@turma_info[:docente]).to have_key(:departamento)
      expect(@turma_info[:docente]).to have_key(:formacao)
      expect(@turma_info[:docente]).to have_key(:usuario)
      expect(@turma_info[:docente]).to have_key(:email)
      expect(@turma_info[:docente]).to have_key(:ocupacao)

      expect(@turma_info).to have_key(:dicente)
      expect(@turma_info[:dicente]).to be_an(Array)
      expect(@turma_info[:dicente]).to all(be_an(Hash))
      expect(@turma_info[:dicente]).to all(have_key :nome)
      expect(@turma_info[:dicente]).to all(have_key :curso)
      expect(@turma_info[:dicente]).to all(have_key :matricula)
      expect(@turma_info[:dicente]).to all(have_key :usuario)
      expect(@turma_info[:dicente]).to all(have_key :formacao)
      expect(@turma_info[:dicente]).to all(have_key :ocupacao)
      expect(@turma_info[:dicente]).to all(have_key :email)
      
    end

    it 'should import the right number of students' do

      expect(@turma_info).to have_key(:dicente)
      expect(@turma_info[:dicente]).to be_an(Array)
      expect(@turma_info[:dicente].length).to eq(34)

    end

    it 'should import the right information about the class' do

      expect(@turma_info).to be_an(Hash)
      expect(@turma_info).to have_key(:code)
      expect(@turma_info[:code]).to eq('CIC105')
      expect(@turma_info).to have_key(:classCode)
      expect(@turma_info[:classCode]).to eq('T02')

    end

    it 'should import the right information about the teacher' do

      expect(@turma_info).to have_key(:docente)
      expect(@turma_info[:docente]).to be_an(Hash)

      expect(@turma_info[:docente]).to have_key(:nome)
      expect(@turma_info[:docente][:nome]).to eq("GENAINA NUNES RODRIGUES")

      expect(@turma_info[:docente]).to have_key(:departamento)
      expect(@turma_info[:docente][:departamento]).to eq("DEPTO CIÊNCIAS DA COMPUTAÇÃO")

      expect(@turma_info[:docente]).to have_key(:formacao)
      expect(@turma_info[:docente][:formacao]).to eq("DOUTORADO")

      expect(@turma_info[:docente]).to have_key(:usuario)
      expect(@turma_info[:docente][:usuario]).to eq("78334926120")

      expect(@turma_info[:docente]).to have_key(:email)
      expect(@turma_info[:docente][:email]).to eq("genaina@unb.br")

      expect(@turma_info[:docente]).to have_key(:ocupacao)
      expect(@turma_info[:docente][:ocupacao]).to eq('docente')

    end

    it 'should import the right information about the students' do

      expect(@turma_info).to have_key(:dicente)
      expect(@turma_info[:dicente]).to be_an(Array)
      expect(@turma_info[:dicente]).to all(be_an(Hash))
      expect(@turma_info[:dicente]).to all(have_key :nome)
      expect(@turma_info[:dicente]).to all(have_key :curso)
      expect(@turma_info[:dicente]).to all(have_key :matricula)
      expect(@turma_info[:dicente]).to all(have_key :usuario)
      expect(@turma_info[:dicente]).to all(have_key :formacao)
      expect(@turma_info[:dicente]).to all(have_key :ocupacao)
      expect(@turma_info[:dicente]).to all(have_key :email)

      yaml_path = "#{Dir.pwd}/spec/services/yaml_files/students_t1.yaml"

      expec_students =  YAML.load_file(yaml_path)

      expect(@turma_info[:dicente]).to eq(expec_students)

    end

  end
end
