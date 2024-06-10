FactoryBot.define do
  factory :form do
    id { 1 }
    open { true }
    created_at { Time.now.utc }
    updated_at { Time.now.utc }
    coordinator_id { 100 }
    subject_class_id { 1 }
  end
end
