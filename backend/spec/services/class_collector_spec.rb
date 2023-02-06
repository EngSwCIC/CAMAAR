require 'rails_helper'

RSpec.describe SigaaManager::ClassCollector, type: :model do
  describe 'getClassesInfo' do
    it 'Should return an array of objects that contains the data of sigaa classes.' do
      #example
      turmasSigaa = [
        {:code=>"CIC0105", :name=>"ENGENHARIA DE SOFTWARE", :class=>{:classCode=>"T02", :semester=>"2022.2", :time=>"35M12"}},
        {:code=>"ENE0040", :name=>"LABORATÓRIO DE SISTEMAS DIGITAIS", :class=>{:classCode=>"T02", :semester=>"2022.2", :time=>"2T23"}},
        {:code=>"CIC0093", :name=>"LINGUAGENS DE PROGRAMACAO", :class=>{:classCode=>"T01", :semester=>"2022.2", :time=>"24M12"}}
      ]

      classesInfo = SigaaManager::ClassCollector.call
      expect(classesInfo).to eq(turmasSigaa)

    end  
  end
end
