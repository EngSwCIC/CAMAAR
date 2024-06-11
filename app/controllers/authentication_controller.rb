class AuthenticationController < ApplicationController
  def login
    render 'login'
  end

  def process_login
    user = User.find_by(email: params[:email])
  
    if user && User.authenticate(user.id, params[:password])
      key = user.generate_session_key
      create_cookie(user, key)
      redirect_to home_index_path
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

  def check_authentication
    if cookies.signed[:user_info].present? && cookies.signed[:user_info].respond_to?(:readonly?) && cookies.signed[:user_info].readonly?
      cookie_value = cookies.signed[:user_info]
      if cookie_value.present?
        key, timestamp, email = cookie_value.split('_')
  
        if Time.current.to_i - timestamp.to_i < 1.hour
          user = User.find_by(email: email)
          # Verifica se o usuário existe e se a chave no cookie corresponde ao email
          return true if user && key == user.session_key
        end
      end
    end
    false
  end  

  private

  def create_cookie(user, key)
    timestamp = Time.current.to_i
    cookie_value = "#{key}_#{timestamp}_#{user.email}"
    cookies.signed[:user_info] = { value: cookie_value, expires: 1.hour.from_now, readonly: true }
  end  
end