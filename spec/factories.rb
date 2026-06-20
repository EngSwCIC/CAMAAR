FactoryBot.define do
  factory :departamento do
    sequence(:nome_departamento) { |n| "Departamento #{n}" }
  end

  factory :usuario do
    sequence(:nome) { |n| "Usuário #{n}" }
    sequence(:email) { |n| "usuario#{n}@example.com" }
    password { "Senha123" }
    password_confirmation { "Senha123" }
    role { :estudante }

    trait :admin do
      role { :admin }
    end

    trait :professor do
      role { :professor }
    end
  end

  factory :admin do
    association :usuario, factory: :usuario, role: :admin
    association :departamento
  end

  factory :criador_formulario do
    association :usuario, factory: :usuario, role: :admin
  end

  factory :materia do
    sequence(:codigoMateria) { |n| "CIC#{n.to_s.rjust(4, '0')}" }
    sequence(:nome_materia) { |n| "Matéria #{n}" }
    association :departamento
  end

  factory :professor do
    association :usuario, factory: :usuario, role: :professor
  end

  factory :turma do
    sequence(:numero_turma) { |n| n }
    semestre_string { "2026/1" }
    association :materia
    association :professor
  end

  factory :estudante do
    sequence(:matricula) { |n| "23100#{n.to_s.rjust(4, '0')}" }
    association :usuario, factory: :usuario, role: :estudante
  end

  factory :matricula do
    trancado { false }
    association :estudante
    association :turma
  end

  factory :template_formulario do
    sequence(:nome_template) { |n| "Template #{n}" }
    association :criador_formulario
  end

  factory :formulario do
    sequence(:nome_formulario) { |n| "Formulário #{n}" }
    publico_estudante { true }
    association :turma
    association :criador_formulario
    association :template_formulario
  end

  factory :resposta_formulario do
    data_resposta { Time.current }
    association :usuario
    association :formulario
  end

  factory :pergunta do
    sequence(:enunciado) { |n| "Pergunta #{n}?" }
    tipo_pergunta { :discursiva }
    gabarito_discursiva { "Resposta padrão" }
    association :template_formulario
  end
end
