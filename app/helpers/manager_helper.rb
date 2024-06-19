module ManagerHelper
  def admin_user?
    user_info = cookies.signed[:user_info]
    return false unless user_info.present?

    _, _, email = user_info.split('_')
    return false unless email.present?

    user = User.find_by(email:)
    user&.is_admin || false
  end

  def current_semester?
    Semester.current_semester
  end
end
