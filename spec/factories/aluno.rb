FactoryBot.define do
  factory :aluno do
    id {1}
    email { "aluno@example.com" }
    encrypted_password { "password" }
    nome { "Nome Aluno" }
    matricula { 123456 }
    curso { "Curso Exemplo" }
    created_at {Time.now.utc}
    updated_at {Time.now.utc}

 
  end
end
