FactoryBot.define do
  factory :questao do
    texto { "Texto da questão." }
    formulario { association :formulario}
    template { association :template}
  end
end
