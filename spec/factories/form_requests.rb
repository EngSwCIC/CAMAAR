FactoryBot.define do
  factory :form_request do
    study_class
    user
    answered { false }
  end
end
