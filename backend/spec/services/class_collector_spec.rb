require 'rails_helper'

RSpec.describe SigaaManager::ClassCollector, type: :model do

  describe 'new' do
    it 'should generate an object with a instane variable corresponding to the initial SIGAA page' do
      extractor = SigaaManager::ClassCollector.new()
      expect((extractor.login_sigga.element(tag_name:'div', id:"turmas-portal", class:"simple-panel").exists?)).to be_truthy
    end
  end

  describe 'getClassesInfo' do
    it 'Should return an array of objects that contains the data of sigaa classes.' do
      #example
    
      classes_info = SigaaManager::ClassCollector.call
      expect(classes_info).to be_an(Array)
      expect(classes_info).to include(hash_including(name: "ENGENHARIA DE SOFTWARE"))
      expect(classes_info).to include(hash_including(code: "CIC0105"))
      expect(classes_info).to include(hash_including(class: be_a(Object)))

    end  
  end

end
