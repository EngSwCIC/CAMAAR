FactoryBot.define do
  factory :class_membership do
    user
    course_class
    role { :discente }
  end
end
