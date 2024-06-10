FactoryBot.define do
  factory :formulario do
    nome { "MyString" }
    turma { association :turma}
    template { association :template}
  end
end
