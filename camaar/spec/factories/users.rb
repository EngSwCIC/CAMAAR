FactoryBot.define do
  factory :user do
    nome { "Ana Clara Jordao Perna" }
    email { "acjpjvjp@gmail.com" }
    password { "123456" }
    curso { "CIÊNCIA DA COMPUTAÇÃO/CIC" }
    matricula { "190084006" }
    formacao { "graduando" }
    ocupacao { "dicente" }
    password { "123456789" }
    role { :user }
    password_confirmation { "123456789" }
    reset_password_token{ nil }
    reset_password_sent_at { nil }
    remember_created_at { nil }
  end
end
