module ApplicationHelper
  def admin?
    session[:user_type] == 'admin'
  end

  def discente?
    session[:user_type] == 'discente'
  end

  def docente?
    session[:user_type] == 'docente'
  end
end