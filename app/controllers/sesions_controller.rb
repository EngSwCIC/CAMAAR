class SessionsController < ApplicationController
  def new
    return unless logged_in?

    if current_user.perfil == "administrador"
      redirect_to admin_dashboard_path
    else
      redirect_to avaliacoes_path
    end
  end

  def create
    credencial = params[:email]&.strip
    senha = params[:password]

    if credencial.blank? || senha.blank?
      flash.now[:alert] = "Preencha todos os campos obrigatórios"
      render :new, status: :unprocessable_entity
      return
    end

    usuario = Usuario.find_by(email: credencial) || Usuario.find_by(matricula: credencial)

    if usuario
      if usuario.senha_hash.blank? || (usuario.setup_token.present? && !usuario.setup_token_used?)
        flash.now[:alert] = "Cadastro pendente: Verifique seu e-mail para definir sua senha de acesso."
        render :new, status: :unprocessable_entity
        return
      end

      if usuario.authenticate(senha)
        if usuario.ativo?
          session[:usuario_id] = usuario.id
          flash[:notice] = "Bem-vindo, #{usuario.nome}!"
          if usuario.perfil == "administrador"
            redirect_to admin_dashboard_path
          else
            redirect_to avaliacoes_path
          end
        else
          flash.now[:alert] = "Usuário inativo. Entre em contato com o administrador"
          render :new, status: :unprocessable_entity
        end
      else
        if credencial.match?(/^\d+$/)
          flash.now[:alert] = "Matrícula ou senha inválidos"
        else
          flash.now[:alert] = "E-mail ou senha inválidos"
        end
        render :new, status: :unprocessable_entity
      end
    else
      if credencial.match?(/^\d+$/)
        flash.now[:alert] = "Matrícula ou senha inválidos"
      elsif !credencial.include?("@")
        flash.now[:alert] = "E-mail inválido"
      else
        flash.now[:alert] = "E-mail ou senha inválidos"
      end
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:usuario_id] = nil
    flash[:notice] = "Você saiu do sistema com sucesso."
    redirect_to login_path
  end
end
