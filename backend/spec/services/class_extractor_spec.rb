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
      turma = {"codigo" => 'CIC105',
               "turma" => "T02" }

      browser = Watir::Browser.new :chrome, headless: true
      browser.goto file_url

      @turma_info = @extractor.extract_class( turma, browser)
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

      expec_students =  [
        {:nome=>"Bruno Berto de Oliveira Ribeiro", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"CIÊNCIA DA COMPUTAÇÃO/CIC", :matricula=>"200061089", :usuario=>"200061089", :email=>"brunoberto2001@gmail.com"},
        {:nome=>"Cleidson Deusdara Chagas de Oliveira", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"CIÊNCIA DA COMPUTAÇÃO/CIC", :matricula=>"180052250", :usuario=>"180052250", :email=>"gk.cleidson@yahoo.com.br"},
        {:nome=>"Davi Jesus de Almeida Paturi", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"CIÊNCIA DA COMPUTAÇÃO/CIC", :matricula=>"200016784", :usuario=>"200016784", :email=>"davipaturi@gmail.com"},
        {:nome=>"Davi Oliveira Fuzo", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"ENGENHARIA DE COMPUTAÇÃO/CIC", :matricula=>"202024446", :usuario=>"202024446", :email=>"davifuzo@gmail.com"},
        {:nome=>"David Herbert de Souza Brito", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"ENGENHARIA DE COMPUTAÇÃO/CIC", :matricula=>"200057405", :usuario=>"200057405", :email=>"davidherbertsb@gmail.com"},
        {:nome=>"Eduardo Afonso da Silva Inácio", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"ENGENHARIA DE COMPUTAÇÃO/CIC", :matricula=>"221033920", :usuario=>"221033920", :email=>"221033920@aluno.unb.br"},
        {:nome=>"Edy William Siqueira de Meneses", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"ENGENHARIA DE COMPUTAÇÃO/CIC", :matricula=>"180135287", :usuario=>"180135287", :email=>"edywill@gmail.com"},
        {:nome=>"Emanuel Firmino Abrantes", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"ENGENHARIA DE COMPUTAÇÃO/CIC", :matricula=>"190105747", :usuario=>"190105747", :email=>"ddos.emanuel@gmail.com"},
        {:nome=>"ERICA DA CUNHA FERREIRA", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"ENGENHARIA MECATRÔNICA - CONTROLE E AUTOMAÇÃO/FTD", :matricula=>"221038417", :usuario=>"221038417", :email=>"ericacunhaferreira0@gmail.com"},
        {:nome=>"FILIPE DE SOUSA FERNANDES", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"CIÊNCIA DA COMPUTAÇÃO/CIC", :matricula=>"202065879", :usuario=>"202065879", :email=>"filipe.sf04@gmail.com"},
        {:nome=>"Gabriel Alvares de Faria", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"COMPUTAÇÃO/CIC", :matricula=>"190106824", :usuario=>"190106824", :email=>"gafaria3@icloud.com"},
        {:nome=>"Gabriel da Silva Corvino Nogueira", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"CIÊNCIA DA COMPUTAÇÃO/CIC", :matricula=>"180113330", :usuario=>"180113330", :email=>"gab.nog94@gmail.com"},
        {:nome=>"GUSTAVO BARBOSA DE ALMEIDA", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"COMPUTAÇÃO/CIC", :matricula=>"202037589", :usuario=>"202037589", :email=>"202037589@aluno.unb.br"},
        {:nome=>"Kléber Rodrigues da Costa Júnior", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"CIÊNCIA DA COMPUTAÇÃO/CIC", :matricula=>"200053680", :usuario=>"200053680", :email=>"kleberrjr7@gmail.com"},
        {:nome=>"Leonardo Vargas Cabral", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"ENGENHARIA DE COMPUTAÇÃO/CIC", :matricula=>"190046953", :usuario=>"190046953", :email=>"lvccrvgbr@gmail.com"},
        {:nome=>"Lucas Resende Silveira Reis", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"CIÊNCIA DA COMPUTAÇÃO/CIC", :matricula=>"180144421", :usuario=>"180144421", :email=>"180144421@aluno.unb.br"},
        {:nome=>"Lucas Silva Veloz", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"COMPUTAÇÃO/CIC", :matricula=>"190091827", :usuario=>"190091827", :email=>"lurucell@gmail.com"},
        {:nome=>"Lucas Sousa Borges", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"ENGENHARIA DE COMPUTAÇÃO/CIC", :matricula=>"160052408", :usuario=>"160052408", :email=>"lborges343@gmail.com"},
        {:nome=>"Maria Clara Mendes Goncalves", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"CIÊNCIA DA COMPUTAÇÃO/CIC", :matricula=>"190100168", :usuario=>"190100168", :email=>"mariaclara.mendes@gmail.com"},
        {:nome=>"MARIA EDUARDA CARVALHO SANTOS", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"CIÊNCIA DA COMPUTAÇÃO/CIC", :matricula=>"190092556", :usuario=>"190092556", :email=>"auntduda@gmail.com"},
        {:nome=>"Mateus Lúcio Silva Mariano", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"ENGENHARIA DE COMPUTAÇÃO/CIC", :matricula=>"170151727", :usuario=>"170151727", :email=>"luciomateus100@hotmail.com"},
        {:nome=>"Mateus Valerio Fernandes", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"CIÊNCIA DA COMPUTAÇÃO/CIC", :matricula=>"190035161", :usuario=>"190035161", :email=>"mateusvalerio1@gmail.com"},
        {:nome=>"MATHEUS LACERDA DA SILVEIRA", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"ENGENHARIA DE COMPUTAÇÃO/CIC", :matricula=>"201000136", :usuario=>"201000136", :email=>"MATHEUSLACERDADASILVEIRA@GMAIL.COM"},
        {:nome=>"Nataly Lacerda de Oliveira", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"ENGENHARIA DE COMPUTAÇÃO/CIC", :matricula=>"190093838", :usuario=>"190093838", :email=>"nat.lacerda10@gmail.com"},
        {:nome=>"Pedro Henrique dos Santos", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"CIÊNCIA DA COMPUTAÇÃO/CIC", :matricula=>"200026127", :usuario=>"200026127", :email=>"pedrosantosmain@gmail.com"},
        {:nome=>"Robert Santos Vieira", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"ENGENHARIA DE COMPUTAÇÃO/CIC", :matricula=>"180077911", :usuario=>"180077911", :email=>"rsvieira08@gmail.com"},
        {:nome=>"Ruan Petrus Alves Leite", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"CIÊNCIA DA COMPUTAÇÃO/CIC", :matricula=>"211010459", :usuario=>"200043323", :email=>"pedraruan12@gmail.com"},
        {:nome=>"Silvio Castanheira Oddone da Silva Dias", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"COMPUTAÇÃO/CIC", :matricula=>"180138502", :usuario=>"180138502", :email=>"silvio.oddone@terra.com.br"},
        {:nome=>"Thiago Rigotto Stachuk", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"COMPUTAÇÃO/CIC", :matricula=>"190139331", :usuario=>"190139331", :email=>"thiagorigstak@gmail.com"},
        {:nome=>"Thiago Vale Giffoni", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"ENGENHARIA DE COMPUTAÇÃO/CIC", :matricula=>"200073303", :usuario=>"200073303", :email=>"thiago.giff@gmail.com"},
        {:nome=>"Tiago de Souza Fernandes", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"ENGENHARIA DE COMPUTAÇÃO/CIC", :matricula=>"180131818", :usuario=>"180131818", :email=>"tiagotsf2000@gmail.com"},
        {:nome=>"Vanessa Paixao Costa", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"ENGENHARIA DE COMPUTAÇÃO/CIC", :matricula=>"200028286", :usuario=>"200028286", :email=>"vanessapaixaocosta@gmail.com"},
        {:nome=>"VITOR CAMILO LEMOS", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"COMPUTAÇÃO/CIC", :matricula=>"202037720", :usuario=>"202037720", :email=>"vitorcamilolemos@gmail.com"},
        {:nome=>"Weliton Cesar Pereira Barreto", :ocupacao=>"dicente", :formacao=>"graduando", :curso=>"CIÊNCIA DA COMPUTAÇÃO/CIC", :matricula=>"200044532", :usuario=>"200044532", :email=>"welitoncpb@gmail.com"}]

      expect(@turma_info[:dicente]).to eq(expec_students)

    end

  end
end
