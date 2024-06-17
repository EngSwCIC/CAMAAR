class RegistrationsController < ApplicationController
  def index
    render 'create'
  end

  def create
    email = user_params[:email]
    password = user_params[:password]
    password_confirmation = user_params[:password_confirmation]
    key = user_params[:key]
    
    if email.blank? || password.blank? || password_confirmation.blank? || key.blank?
      flash[:error] = "Todos os campos devem ser preenchidos."
      render :create
      return
    end    

    # Verifica se o email e a chave estão disponíveis na tabela SignUpAvailable
    if SignUpAvailable.check_availability(email, key)
      if User.find_by(email: email)
        flash[:error] = "Email já cadastrado, entre em contato com o administrador."
        render :create
        return
      else
        @user = User.criarUser(email, password, password_confirmation)

        if @user.present? && @user.persisted?
          redirect_to login_path, notice: "Usuário criado com sucesso!"
        else
          flash[:error] = "As senhas devem coincidir."
          render :create
          return
        end
      end
    else
      flash[:error] = "Email ou chave de cadastro inválidos, entre em contato com seu coordenador."
      render :create
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :key)
  end
end
