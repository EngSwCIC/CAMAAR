FactoryBot.define do
    factory :survey do
        name { 'Survey' }
        description { 'Test Survey' }
        expiration_date { DateTime.now() }
        semester { 'Semester' }
    end
end