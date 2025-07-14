class AuthenticatedController < ApplicationController
  before_action :authorized, only: [ :home, :admin ]

  def home
    return head :unauthorized unless logged_in?
    user = current_user

    class_group_ids = []
    class_group_ids += user.class_students.pluck(:class_group_id) if user.respond_to?(:class_students)
    class_group_ids += user.class_professors.pluck(:class_group_id) if user.respond_to?(:class_professors)
    class_group_ids.uniq!

    forms = Form.joins(:class_forms)
                .where(class_forms: { class_group_id: class_group_ids })
                .distinct

    @forms_data = forms.map do |form|
      class_group = form.class_forms.first&.class_group
      next unless class_group
      professor = class_group.class_professors.first&.professor
      {
        id: class_group.id,
        subject: class_group.subject&.name,
        semester: class_group.semester,
        professor: professor&.name,
        answered: AnsweredForm.exists?(user_id: user.id, form_id: form.id)
      }
    end.compact
  end

  def admin
  end
end
