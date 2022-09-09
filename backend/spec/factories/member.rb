FactoryBot.define do
    factory :member do
        name { 'test name' }
        registration { '200010100' }
        username { 'bom dia name' }
        degree { 'Computer Science' }
        course { 'morning' }
        email { 'email@test.io' }
        role { create(:role) }
    end
end