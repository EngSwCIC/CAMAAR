FactoryBot.define do
  factory :questao do
    texto { "MyString" }
    formulario { association :formulario}
    template { association :template}
  end
end
