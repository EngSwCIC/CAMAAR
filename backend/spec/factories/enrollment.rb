FactoryBot.define do
    factory :enrollment do
        grade { 50 }
        cclass { create(:cclass) }
        member { create(:member) }
    end
end