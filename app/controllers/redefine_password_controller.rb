class RedefinePasswordController < ApplicationController
    def index
      if authenticate_user == true
        render :index
      else
        redirect_to root_path, alert: "Acesso não autorizado"
      end
    end
    
    def redefine
        user_info = cookies.signed[:user_info]
        key, timestamp, email = user_info.split('_')

        password = params[:user][:password]
        password_confirmation = params[:user][:password_confirmation]
        
        if email.blank? || password.blank? || password_confirmation.blank?
          flash[:error] = "Todos os campos devem ser preenchidos."
          render :index
          return
        end
        
        user = User.find_by(email: email)
        
        if user.nil?
          flash[:error] = "Usuário não encontrado."
          render :index
          return
        end
        
        if password != password_confirmation
          flash[:error] = "As senhas devem coincidir."
          render :index
          return
        end
        
        salt = BCrypt::Engine.generate_salt
        hashed_password = BCrypt::Engine.hash_secret(password, salt)
        
        if user.update(password: hashed_password, salt: salt)
          redirect_to login_path, notice: "Senha redefinida com sucesso!"
        else
          flash[:error] = "Erro ao redefinir a senha. Tente novamente."
          render :index
        end
      end
    
      private
    
      def user_params
        params.require(:user).permit(:password, :password_confirmation)
      end
end