# frozen_string_literal: true

class SessionsController < ApplicationController
  # Desativa o layout padrão para esta página específica
  # Ignora a verificação de login para as páginas de 'new' (formulário) e 'create' (processamento)
  skip_before_action :require_login, only: %i[new create]
  layout false, only: [:new] # Continua sem layout na página de login

  def new
    # Renderiza o formulário de login
  end

  def create
    user = User.find_by(email: params[:email].downcase)

    # Verifica se o usuário existe E se a senha está correta
    begin
      if user && user.password_digest.present? && user.authenticate(params[:password])
        # Se estiver tudo certo, armazena o ID do usuário na sessão
        session[:user_id] = user.id
        redirect_to evaluations_path, notice: 'Login realizado com sucesso!'
      else
        # Se falhar, mostra uma mensagem de erro e renderiza o formulário de novo
        flash.now[:alert] = 'Email ou senha inválidos.'
        render :new, status: :unprocessable_entity
      end
    rescue BCrypt::Errors::InvalidHash
      # Trata o erro de hash inválido
      flash.now[:alert] = 'Erro na autenticação. Entre em contato com o administrador.'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    # Apaga a sessão do usuário
    session[:user_id] = nil
    redirect_to login_path, notice: 'Você saiu com segurança.'
  end
end
