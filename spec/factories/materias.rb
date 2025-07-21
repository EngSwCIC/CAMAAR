FactoryBot.define do
  factory :materia do
    sequence(:id) { |n| "CIC#{format('%03d', n)}" } 
    nome { "Matemática" }
  end
end