# Gerencia o ciclo de vida da sessão de autenticação do usuário.
#
# Responsável pelo login (criação de sessão com verificação de credenciais via
# email ou matrícula) e pelo logout (destruição da sessão). Redireciona o usuário
# para a página correta de acordo com o seu perfil (+Administrador+ ou demais).
class SessionsController < ApplicationController
  # Exibe o formulário de login.
  #
  # @return [void]
  # @note Redireciona para a página do usuário caso já exista uma sessão ativa.
  def new
    if current_user
      redirect_para_pagina_do_usuario(current_user)
    end
  end

  # Autentica o usuário com as credenciais informadas e inicia a sessão.
  #
  # @return [void]
  # @note Lê os parâmetros +:login+ (email ou matrícula) e +:senha+ do formulário.
  #   Redireciona para a página raiz com alerta em caso de falha (login em branco, senha
  #   em branco, usuário não encontrado, cadastro não efetivado ou senha incorreta).
  #   Em caso de sucesso, armazena o id do usuário na sessão e redireciona para a sua
  #   página de avaliações.
  def create
    login = params[:login].to_s.strip
    senha = params[:senha].to_s

    if login.blank?
      redirect_to root_path, alert: "Falha no login: informe seu email ou matrícula"
      return
    end

    if senha.blank?
      redirect_to root_path, alert: "Falha no login: informe a sua senha"
      return
    end

    usuario = Usuario.find_by(email: login) || Usuario.find_by(matricula: login)

    if usuario.blank?
      redirect_to root_path, alert: "Falha no login: usuário não encontrado"
      return
    end

    unless usuario.senha_definida?
      redirect_to root_path, alert: "Falha no login: usuário existente deve efetivar o seu cadastro por email"
      return
    end

    unless usuario.autenticar_senha(senha)
      redirect_to root_path, alert: "Falha no login: senha incorreta"
      return
    end

    session[:usuario_id] = usuario.id
    redirect_para_pagina_do_usuario(usuario)
  end

  # Encerra a sessão do usuário atual.
  #
  # @return [void]
  # @note Limpa todos os dados da sessão e redireciona para a página raiz.
  def destroy
    reset_session
    redirect_to root_path
  end

  private

  # Redireciona para a página de avaliações correspondente ao tipo do usuário.
  #
  # @param usuario [Usuario] o usuário cuja página será exibida
  # @return [void]
  # @note Administradores são redirecionados para +admin_avaliacoes_path+;
  #   demais usuários para +usuarios_avaliacoes_path+.
  def redirect_para_pagina_do_usuario(usuario)
    if usuario.is_a?(Administrador)
      redirect_to admin_avaliacoes_path(usuario.id), notice: "Login realizado com sucesso."
    else
      redirect_to usuarios_avaliacoes_path(usuario.id), notice: "Login realizado com sucesso."
    end
  end
end
