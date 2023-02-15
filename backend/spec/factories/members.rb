FactoryBot.define do
  factory :member do
    name {"Senhor Barbecue"}
    registration {190023234}
    username {"xurrasco_021"}
    degree {"Graduação"}
    course {"Engenharia de Computação"}
    email {"xurrasco_021@aluno.unb.br"}
    role {create(:role)}
  end
end
