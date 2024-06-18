module AuthenticationConcern
  extend ActiveSupport::Concern

  def authenticate_user
    user_info = cookies.signed[:user_info]
    return check_authentication_from_controller(user_info)
  end

  def check_authentication_from_controller(cookie_value)
    return false unless cookie_value.present?
    key, timestamp, email = cookie_value.split('_')
    return false unless key && timestamp && email
  
    user = User.find_by(email: email)
    if user && key == user.session_key
      if Time.current.to_i - timestamp.to_i < 1.hour
        return true
      else
        user.update(session_key: nil)
        cookies.delete(:user_info)
        return false
      end
    else
      cookies.delete(:user_info)
      return false
    end
  end
end
