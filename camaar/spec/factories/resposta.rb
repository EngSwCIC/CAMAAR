FactoryBot.define do
  factory :resposta do
    texto { "Texto exemplo de uma resposta." }
    formulario { association :formulario }
    questao { association :questao}
  end
end
