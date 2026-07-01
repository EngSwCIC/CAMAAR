# Gerencia autenticação de usuários: login e logout.
class SessionsController < ApplicationController
  # Exibe o formulário de login.
  #
  # Efeito colateral: redireciona para a página inicial do perfil caso o
  # usuário já esteja autenticado (admin vai para +admin_root_path+,
  # discente/docente vai para +avaliacoes_path+).
  def new
    if logged_in?
      redirect_to is_admin? ? admin_root_path : avaliacoes_path
    end
  end

  # Processa as credenciais enviadas pelo formulário de login.
  #
  # Parâmetros: +:login+ (e-mail ou matrícula) e +:password+ via params.
  # Efeito colateral: grava +:pessoa_id+ na sessão e redireciona para a
  # página inicial do perfil em caso de sucesso, ou renderiza o formulário
  # novamente com alerta em caso de falha.
  def create
    pessoa = autenticar_pessoa(params[:login], params[:password])
    return rejeitar_login unless pessoa

    session[:pessoa_id] = pessoa.usuario
    redirect_to pessoa.admin? ? admin_root_path : avaliacoes_path
  end

  # Encerra a sessão do usuário autenticado.
  #
  # Efeito colateral: limpa +:pessoa_id+ da sessão e redireciona para
  # +login_path+ com mensagem de confirmação.
  def destroy
    session[:pessoa_id] = nil
    redirect_to login_path, notice: "Logout realizado com sucesso."
  end

  private

  # Busca e autentica uma pessoa pelo e-mail ou matrícula e senha.
  #
  # Parâmetros: +login+ (String) — e-mail ou matrícula; +password+ (String).
  # Retorno: instância de +Pessoa+ autenticada ou +nil+ se as credenciais
  # forem inválidas.
  def autenticar_pessoa(login, password)
    pessoa = Pessoa.find_by(email: login) || Pessoa.find_by(usuario: login)
    pessoa if pessoa&.authenticate(password)
  end

  # Renderiza o formulário de login com mensagem de erro.
  #
  # Efeito colateral: define +flash.now[:alert]+ e renderiza a action +:new+
  # com status 422.
  def rejeitar_login
    flash.now[:alert] = "Identificação ou senha inválidos. Verifique suas credenciais e tente novamente."
    render :new, status: :unprocessable_entity
  end
end
