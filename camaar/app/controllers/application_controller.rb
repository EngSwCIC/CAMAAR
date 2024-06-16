class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  skip_before_action :verify_authenticity_token

  def after_sign_in_path_for(_resource)
    if admin_signed_in? # Assuming there is such a function
      # admins_page_path
      templates_path
    elsif user_signed_in?
      '/users/forms'
    else
      root_path
    end
  end

  protected

  def configure_permitted_parameters
    added_attrs = %i[email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: %i[email password]
    devise_parameter_sanitizer.permit :define, keys: [:email]
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def set_admin_data
    @errors = []
    @coordinator = Coordinator.find_by({ email: current_admin.email })
    @department = Department.find_by_id(@coordinator.department_id) if @coordinator
    @classes = SubjectClass.where(department_id: @coordinator.department_id) if @coordinator
    @teachers = Teacher.where(department_id: @coordinator.department_id) if @coordinator
  end

  def set_user_data
    student = Student.find_by(email: current_user.email)
    if student
      @student = student
      current_user.occupation = student.occupation
      # current_user.name = student.name
      current_user.name = student.name.split.first.capitalize
      @department = Department.find_by(initials: student.course.split('/').last) if student
    else
      @teacher = Teacher.find_by(email: current_user.email)
      current_user.occupation = @teacher.occupation
      current_user.name = @teacher.name.split.first.capitalize
      @department = Department.find_by_id(@teacher.department_id) if @teacher
    end
  end
end
