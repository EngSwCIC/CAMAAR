FactoryBot.define do
  factory :user do
    nome { "Ana Clara Jordao Perna" }
    email { "acjpjvjp@gmail.com" }
    password	{ "123456" }
    curso { "CIÊNCIA DA COMPUTAÇÃO/CIC" }
    matricula { "190084006" }
    formacao { "graduando" }
    ocupacao { "dicente" }
    admin { false }
  end
end
