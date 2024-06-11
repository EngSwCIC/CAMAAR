class AuthenticationController < ApplicationController
  include AuthenticationConcern

  def login
    render 'login'
  end

  def process_login
    user = User.find_by(email: params[:email])
    if user && User.authenticate(user.id, params[:password])
      key = user.generate_session_key
      create_cookie(user, key)
      redirect_to home_path
    else
      flash[:error] = "Não foi possível fazer login"
      redirect_to login_path
    end
  end
  
  def logout
    if cookies.signed[:user_info].present? && cookies.signed[:user_info].readonly?
      cookie_value = cookies.signed[:user_info]
      key, timestamp, email = cookie_value.split('_')
  
      user = User.find_by(email: email)
      if user && key == user.session_key
        user.update(session_key: nil)
        cookies.delete(:user_info)
      end
    end
    redirect_to login_path
  end

  private def create_cookie(user, key)
    timestamp = Time.current.to_i
    cookie_value = "#{key}_#{timestamp}_#{user.email}"
    cookies.signed[:user_info] = { value: cookie_value, expires: 1.hour.from_now }
  end
end