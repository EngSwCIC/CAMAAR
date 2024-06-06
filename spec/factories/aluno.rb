# spec/factories/alunos.rb
FactoryBot.define do
    factory :aluno do
      nome { "Nome do Aluno" }
      email { "aluno@example.com" }
      senha { "password" }
    end
  end
  