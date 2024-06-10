FactoryBot.define do
  factory :admin do
    id { 100 }
    email { 'mandelli@unb.br' }
    password { 'abc123' }
    password_confirmation { 'abc123' }
    confirmed_at { Time.now.utc }
  end
end
