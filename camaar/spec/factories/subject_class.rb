FactoryBot.define do
  factory :subject_class do
    id { 1 }
    semester { 'primeiro' }
    subject { 'a' }
    code { 'b' }
    name { 'c' }
    schedule { 'd' }
    created_at { Time.now.utc }
    updated_at { Time.now.utc }
    department_id { 508 }
    teacher_id { 100 }
  end
end
