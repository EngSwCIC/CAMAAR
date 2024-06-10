FactoryBot.define do
  factory :formulario do
    nome { "Avaliação A" }
    turma { association :turma}
    template { association :template}
  end
end
