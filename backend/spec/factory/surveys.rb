FactoryBot.define do
    factory :survey do
        name { 'Survey Test' }
        description { 'Survey Testing' }
        expiration_date { DateTime.now() }
        semester { 'Test Semester' }
    end
end