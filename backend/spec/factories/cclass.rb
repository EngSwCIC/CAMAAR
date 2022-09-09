FactoryBot.define do
    factory :cclass do
        code { 'T0' }
        semester { '2022/2' }
        time { '35M12' }
        subject { create(:subject) } 
    end
end