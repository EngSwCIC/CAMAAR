FactoryBot.define do
  factory :member do
    email { 'email@email' }
    name { 'name' }
    course { 'course' }
    registration { '123' }
    username { '123' }
    degree { 'graduação' }
    redefinition_link { 'link_correto_de_redefinicao_de_senha' }

    association :role
  end
end
