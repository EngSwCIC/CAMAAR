FactoryBot.define do
  factory :teacher do
    id { 100 }
    registration { 27_612_295_172 }
    name { 'FERNANDO CHACON' }
    formation { 'DOUTORADO' }
    occupation { 'docente' }
    email { 'chacon@unb.br' }
    created_at { Time.now.utc }
    updated_at { Time.now.utc }
    department_id { 508 }
    user_id { 100 }
  end
end
