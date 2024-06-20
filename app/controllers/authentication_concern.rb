module AuthenticationConcern
  extend ActiveSupport::Concern

  def user_authenticated
    user_info = cookies.signed[:user_info]
    check_authentication_from_controller(user_info)
  end

  def logged_user
    return unless user_authenticated

    email = cookies.signed[:user_info].split('_').last
    User.find_by(email:)
  end

  def check_authentication_from_controller(cookie_value)
    return false unless cookie_value.present?

    key, timestamp, email = cookie_value.split('_')
    return false unless key && timestamp && email

    user = User.find_by(email:)
    if user && key == user.session_key
      return true if Time.current.to_i - timestamp.to_i < 1.hour

      user.update(session_key: nil)
      cookies.delete(:user_info)
      false

    else
      cookies.delete(:user_info)
      false
    end
  end

  def user_belongs_to?(disciplines)
    disciplines = [disciplines] unless disciplines.respond_to?('each')
    disciplines.each do |discipline|
      return true if StudentDiscipline.where(student_email: logged_user.email,
                                             discipline_code: discipline.code).first
    end
    false
  end
end
