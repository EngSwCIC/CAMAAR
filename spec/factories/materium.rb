FactoryBot.define do
  factory :materium do
    codigo { 1 }
    semestre { 1 }
    nome { "Matéria Exemplo" }
    horario {Time.now.utc }
    created_at {Time.now.utc}
    updated_at {Time.now.utc}

  end
end
