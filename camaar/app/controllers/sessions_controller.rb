class SessionsController < Devise::SessionsController
  def new
    # rota que leva para a root do programa
    render 'devise/sessions/login.html.erb'
  end

  def after_sign_in_path_for(resource)
    # no futuro, outra rota deve ser criada, pois o user pode ser um
    # administrador ou um usuário
    # e esses 2 tipos diferentes de users tem views diferentes para suas homepages

    # no momento, o programa tem configurado apenas a rota que leva para a view homepage de aluno
    # localizada em views/pages/home.html.erb
    home_path
  end


  def create
    # ainda não sei para que isso serve, mas é para criar uma sessão de usuário
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_navigational_format?
    sign_in(resource_name, resource)
    if !session[:return_to].blank?
      redirect_to session[:return_to]
      session[:return_to] = nil
    else
      respond_with resource, :location => after_sign_in_path_for(resource)
    end
  end
end
