FactoryBot.define do
  factory :aluno do
    password {'teste123456'}
    nome { Faker::Name.name }
    email { Faker::Internet.email }
    curso { Faker::Educator.subject }
    matricula { Faker::Number.unique.number(digits: 8) }
  end
end