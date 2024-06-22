FactoryBot.define do
  factory :matricula do
    turma { association :turma }
    user { association :user}
  end
end
