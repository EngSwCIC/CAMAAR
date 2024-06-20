FactoryBot.define do
  factory :form_request do
    study_class { nil }
    user { nil }
    answered { false }
  end
end
