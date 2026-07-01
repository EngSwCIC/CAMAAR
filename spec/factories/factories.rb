# spec/factories/factories.rb
#
# CORREÇÃO: factories usam `password:` (não `senha_hash:`)
# has_secure_password aceita `password` e armazena em `password_digest`
#
FactoryBot.define do
  factory :user do
    sequence(:nome)      { |n| "User #{n}" }
    sequence(:email)     { |n| "user#{n}@unb.br" }
    sequence(:matricula) { |n| "9000#{n.to_s.rjust(5, '0')}" }
    perfil               { "Discente" }
    password             { "Senha123!" }
    primeiro_acesso      { false }
  end

  factory :usuario do
    sequence(:login) { |n| "usuario#{n}" }
    sequence(:email) { |n| "usuario#{n}@unb.br" }
    sequence(:nome)  { |n| "Usuário #{n}" }
    password         { "Senha123!" }   # ← era senha_hash: (errado)
    perfil           { :discente }
    primeiro_acesso  { false }
  end

  factory :departamento do
    sequence(:nome) { |n| "Departamento #{n}" }
  end

  factory :docente do
    association :usuario, perfil: :docente
    association :departamento
  end

  factory :discente do
    association :usuario, perfil: :discente
    sequence(:matricula) { |n| "2000#{n.to_s.rjust(5, '0')}" }
    curso { "CIÊNCIA DA COMPUTAÇÃO/CIC" }
  end

  factory :disciplina do
    sequence(:codigo) { |n| "CIC0#{n.to_s.rjust(3, '0')}" }
    sequence(:nome)   { |n| "Disciplina #{n}" }
  end

  factory :turma do
    association :departamento
    association :disciplina
    association :docente
    sequence(:codigo) { |n| "T#{n}" }
    sequence(:nome)   { |n| "Turma #{n}" }
    semestre { "2024.1" }
    horario  { "35T45" }
  end

  factory :matricula do
    association :discente
    association :turma
  end

  factory :template do
    association :docente
    sequence(:titulo) { |n| "Template #{n}" }
    descricao { "Descrição do template" }
  end

  factory :questao_template do
    association :template
    sequence(:enunciado) { |n| "Como você avalia o item #{n}?" }
    tipo { :aberta }
  end

  factory :opcao_questao do
    association :questao_template
    sequence(:texto) { |n| "Opção #{n}" }
  end

  factory :formulario do
    association :turma
    association :template
    sequence(:titulo) { |n| "Formulário de Avaliação #{n}" }
    prazo { 7.days.from_now }
  end

  factory :questao do
    association :formulario
    association :questao_template
    sequence(:enunciado) { |n| "Questão #{n}" }
    tipo { :aberta }
  end

  factory :envio_formulario do
    association :formulario
    association :discente
    enviado_em { Time.current }
  end

  factory :resposta do
    association :envio_formulario
    association :questao
    conteudo { "Minha resposta de exemplo" }
  end
end
