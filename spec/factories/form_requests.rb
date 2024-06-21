FactoryBot.define do
  factory :form_request do
    study_class
    user
    template
    answered { false }
  end
end
