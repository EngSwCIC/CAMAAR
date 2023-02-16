require 'rails_helper'

RSpec.describe SigaaManager::ClassCollector, type: :model do

  describe 'new' do
    it 'should generate an object with a instane variable corresponding to the initial SIGAA page' do
      extractor = SigaaManager::ClassCollector.new()
      expect((extractor.login_sigga.element(tag_name:'div', id:"turmas-portal", class:"simple-panel").exists?)).to be_truthy
    end
  end

  describe 'get_classes_info' do
    it 'Should return an array of objects that contains the data of sigaa classes.' do

      classes = [
      {"code"=>"CIC0161","name"=>"AUTÔMATOS E COMPUTABILIDADE","class"=>{"classCode"=>"T01","semester"=>"2022.2","time"=>"245T45"}},
      {"code"=>"CIC0105","name"=>"ENGENHARIA DE SOFTWARE","class"=>{"classCode"=>"T02","semester"=>"2022.2","time"=>"35M12"}},
      {"code"=>"CIC0142","name"=>"INFORMATICA E SOCIEDADE","class"=>{"classCode"=>"T02","semester"=>"2022.2","time"=>"6M34"}},
      {"code"=>"CIC0133","name"=>"PROGRAMACAO FUNCIONAL","class"=>{"classCode"=>"T01","semester"=>"2022.2","time"=>"24M34"}}
    ]

      @class_collector = SigaaManager::ClassExtractor.new()
      file_url = "file://#{Dir.pwd}/spec/services/web-pages/pagina_inicial.html"
      browser = Watir::Browser.new :chrome, headless: true
      browser.goto file_url
      classes_info = @class_collector.get_classes_info(browser)
      expect(classes_info).to eq(classes)
    end
  end

  describe 'get_class_info' do
    it 'Should return an array of objects that contains the data of sigaa classes.' do
      eng_software_turma = {"class"=>{"classCode"=>"T02", "semester"=>"2022.2", "time"=>"35M12"}, "code"=>"CIC0105", "name"=>"ENGENHARIA DE SOFTWARE"}
      @class_collector = SigaaManager::ClassExtractor.new()
      file_url = "file://#{Dir.pwd}/spec/services/web-pages/turma2.html"
      browser = Watir::Browser.new :chrome, headless: true
      browser.goto file_url
      class_info = @class_collector.get_class_info(browser)
      expect(class_info).to eq(eng_software_turma)
    end  
  end

end
