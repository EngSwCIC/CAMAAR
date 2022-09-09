FactoryBot.define do
    factory :member_cclass do
        member { create(:member) }
        grade { 80 }
        cclass { create(:cclass) }
    end
end