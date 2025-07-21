FactoryBot.define do
  factory :opcao do
    sequence(:item) { |n| n } 
    opcao { "Opção #{item}" }
    pergunta  
  end
end