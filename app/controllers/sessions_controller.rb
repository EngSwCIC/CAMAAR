class SessionsController < ApplicationController
  # Renderiza a página de login se o usuário não estiver autenticado, ou redireciona-o caso contrário.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * +nil+ ou redirecionamento se o usuário já estiver logado.
  #
  # <b>Efeitos Colaterais:</b>
  # * Redireciona o usuário logado para o painel apropriado (admin ou avaliações).
  def new
    return unless logged_in?

    if current_user.perfil == "administrador"
      redirect_to admin_dashboard_path
    else
      redirect_to avaliacoes_path
    end
  end

  # Processa a tentativa de login autenticando as credenciais fornecidas.
  #
  # <b>Parâmetros:</b>
  # * +params[:email]+ - E-mail ou matrícula digitados pelo usuário (String).
  # * +params[:password]+ - Senha digitada pelo usuário (String).
  #
  # <b>Retorno:</b>
  # * Renderização de template de login em caso de falha, ou redirecionamento em caso de sucesso.
  #
  # <b>Efeitos Colaterais:</b>
  # * Pode definir mensagens de erro no +flash+ ou estabelecer uma sessão de usuário em caso de sucesso.
  def create
    credencial = params[:email]&.strip
    senha = params[:password]

    return render_missing_fields if credencial.blank? || senha.blank?

    authenticate_and_login(credencial, senha)
  end

  # Destrói a sessão atual do usuário (logout).
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Redirecionamento para a página de login.
  #
  # <b>Efeitos Colaterais:</b>
  # * Define +session[:usuario_id]+ como +nil+ e gera mensagem de notificação de saída no +flash+.
  def destroy
    session[:usuario_id] = nil
    flash[:notice] = "Você saiu do sistema com sucesso."
    redirect_to login_path
  end

  private

  # Método auxiliar para encapsular o fluxo de autenticação e validação do estado do usuário.
  #
  # <b>Parâmetros:</b>
  # * +credencial+ - E-mail ou matrícula (String).
  # * +senha+ - Senha do usuário (String).
  #
  # <b>Retorno:</b>
  # * Redirecionamento ou renderização dependendo do resultado da autenticação.
  #
  # <b>Efeitos Colaterais:</b>
  # * Cria sessão ou define erros no +flash+.
  def authenticate_and_login(credencial, senha)
    usuario = find_usuario(credencial)
    return handle_invalid_credentials(credencial) unless usuario
    return handle_pending_setup if pending_setup?(usuario)
    return handle_authentication_failure(credencial) unless usuario.authenticate(senha)
    return handle_inactive_user unless usuario.ativo?

    log_in_user(usuario)
  end

  # Exibe erro caso campos obrigatórios de login não sejam preenchidos.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Renderiza a view de login com status +:unprocessable_entity+.
  #
  # <b>Efeitos Colaterais:</b>
  # * Adiciona alerta ao +flash.now+.
  def render_missing_fields
    flash.now[:alert] = "Preencha todos os campos obrigatórios"
    render :new, status: :unprocessable_entity
  end

  # Busca usuário por e-mail ou matrícula.
  #
  # <b>Parâmetros:</b>
  # * +credencial+ - E-mail ou matrícula (String).
  #
  # <b>Retorno:</b>
  # * Objeto +Usuario+ se encontrado, ou +nil+.
  #
  # <b>Efeitos Colaterais:</b>
  # * Nenhum.
  def find_usuario(credencial)
    Usuario.find_by(email: credencial) || Usuario.find_by(matricula: credencial)
  end

  # Verifica se o cadastro do usuário ainda precisa de configuração de senha inicial.
  #
  # <b>Parâmetros:</b>
  # * +usuario+ - Instância de +Usuario+.
  #
  # <b>Retorno:</b>
  # * Boolean indicando se o cadastro está pendente (+true+) ou concluído (+false+).
  #
  # <b>Efeitos Colaterais:</b>
  # * Nenhum.
  def pending_setup?(usuario)
    usuario.senha_hash.blank? || (usuario.setup_token.present? && !usuario.setup_token_used?)
  end

  # Trata o caso em que o setup inicial do usuário está pendente.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Renderiza a view de login com status +:unprocessable_entity+.
  #
  # <b>Efeitos Colaterais:</b>
  # * Adiciona alerta ao +flash.now+.
  def handle_pending_setup
    flash.now[:alert] = "Cadastro pendente: Verifique seu e-mail para definir sua senha de acesso."
    render :new, status: :unprocessable_entity
  end

  # Trata o fluxo caso o usuário/credencial não exista no banco de dados.
  #
  # <b>Parâmetros:</b>
  # * +credencial+ - E-mail ou matrícula testada (String).
  #
  # <b>Retorno:</b>
  # * Renderiza a view de login com status +:unprocessable_entity+.
  #
  # <b>Efeitos Colaterais:</b>
  # * Adiciona alerta de erro específico ao +flash.now+ baseado no tipo de credencial.
  def handle_invalid_credentials(credencial)
    if credencial.match?(/^\d+$/)
      flash.now[:alert] = "Matrícula ou senha inválidos"
    elsif !credencial.include?("@")
      flash.now[:alert] = "E-mail inválido"
    else
      flash.now[:alert] = "E-mail ou senha inválidos"
    end
    render :new, status: :unprocessable_entity
  end

  # Trata falha na validação de senha de um usuário existente.
  #
  # <b>Parâmetros:</b>
  # * +credencial+ - E-mail ou matrícula (String).
  #
  # <b>Retorno:</b>
  # * Renderiza a view de login com status +:unprocessable_entity+.
  #
  # <b>Efeitos Colaterais:</b>
  # * Define mensagem genérica de erro no +flash.now+.
  def handle_authentication_failure(credencial)
    if credencial.match?(/^\d+$/)
      flash.now[:alert] = "Matrícula ou senha inválidos"
    else
      flash.now[:alert] = "E-mail ou senha inválidos"
    end
    render :new, status: :unprocessable_entity
  end

  # Trata a tentativa de autenticação por um usuário que está marcado como inativo.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Renderiza a view de login com status +:unprocessable_entity+.
  #
  # <b>Efeitos Colaterais:</b>
  # * Adiciona mensagem de usuário inativo ao +flash.now+.
  def handle_inactive_user
    flash.now[:alert] = "Usuário inativo. Entre em contato com o administrador"
    render :new, status: :unprocessable_entity
  end

  # Efetiva o login salvando o ID do usuário na sessão e redirecionando.
  #
  # <b>Parâmetros:</b>
  # * +usuario+ - Objeto +Usuario+ autenticado.
  #
  # <b>Retorno:</b>
  # * Redirecionamento de rota.
  #
  # <b>Efeitos Colaterais:</b>
  # * Grava +session[:usuario_id]+ e define mensagem de boas-vindas no +flash+.
  def log_in_user(usuario)
    session[:usuario_id] = usuario.id
    flash[:notice] = "Bem-vindo, #{usuario.nome}!"
    if usuario.perfil == "administrador"
      redirect_to admin_dashboard_path
    else
      redirect_to avaliacoes_path
    end
  end
end
