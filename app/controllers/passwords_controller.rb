class PasswordsController < ApplicationController
  def edit
    @pessoa = Pessoa.find_by!(reset_password_token: params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to login_path, alert: "Link inválido ou expirado."
  end

  def update
    @pessoa = Pessoa.find_by!(reset_password_token: params[:id])
    if params[:pessoa][:password] != params[:pessoa][:password_confirmation]
      flash.now[:alert] = "As senhas não coincidem"
      render :edit, status: :unprocessable_entity
      return
    end

    if @pessoa.update(password_params)
      @pessoa.update(reset_password_token: nil, reset_password_sent_at: nil)
      redirect_to login_path, notice: "Senha definida com sucesso! Agora você pode acessar o Camaar."
    else
      flash.now[:alert] = "As senhas não coincidem"
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:pessoa).permit(:password, :password_confirmation)
  end
end