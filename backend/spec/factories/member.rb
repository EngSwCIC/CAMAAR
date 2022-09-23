FactoryBot.define do
    factory :member do
        name { 'test name' }
        registration { "#{rand(20000000..90000000)}" }
        username { 'bom dia name' }
        degree { 'Computer Science' }
        course { 'morning' }
        email { 'email@test.io' }
        role { create(:role) }
    end
end