FactoryBot.define do
  factory :resposta do
    formulario
    pergunta
    conteudo { "Resposta teste" }
  end
end