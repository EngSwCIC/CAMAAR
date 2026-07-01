# frozen_string_literal: true

require "json"
require "net/http"
require "uri"

# Controlador responsável por toda a autenticação de usuários do sistema:
# cadastro (primeiro acesso), login, logout e redefinição de senha.
#
# Os fluxos de cadastro e redefinição de senha funcionam em duas etapas:
# 1. O usuário solicita a operação (informando matrícula/e-mail) e recebe
#    um e-mail com um link contendo um token de uso único e validade de
#    10 minutos (veja Token).
# 2. O usuário acessa o link, informa a nova senha e confirma a operação,
#    momento em que o token é validado e destruído.
class AuthController < ApplicationController
  include BrevoEmailable

  # Tamanho mínimo, em caracteres, exigido para qualquer senha cadastrada
  # ou redefinida no sistema.
  TAMANHO_MINIMO_SENHA = 8

  before_action :impedir_se_logado,
    only: %i[solicitar_cadastro cadastrar solicitar_redef_senha redefinir_senha]
  before_action :validar_token_via_url, only: %i[cadastrar redefinir_senha]

  ##
  # Action raiz do sistema (página inicial / formulário de login).
  #
  # Argumentos:
  # - Nenhum (action de controller, usa apenas a sessão atual).
  # Retorno:
  # - Não possui retorno relevante; quando há usuário logado a
  #           action interrompe a execução com +return+.
  # Efeitos colaterais:
  # - Se já existir um usuário autenticado na sessão
  #                      (+current_user+), redireciona para a página de
  #                      avaliações com uma flash de aviso. Caso contrário,
  #                      apenas renderiza a view padrão (index).
  def index
    return unless current_user.present?

    redirect_to avaliacoes_path,
      flash: { notice: "Você já está conectado no sistema. Se quiser sair, faça log out" }
  end

  ##
  # Exibe o formulário de solicitação de cadastro (primeiro acesso).
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - Nenhum (apenas renderiza a view correspondente).
  # Efeitos colaterais:
  # - Nenhum além da renderização da view padrão.
  def solicitar_cadastro
  end

  ##
  # Exibe o formulário de confirmação de cadastro (definição de senha),
  # acessado a partir do link enviado por e-mail.
  #
  # Argumentos:
  # - Nenhum diretamente; depende do +params[:token]+ presente
  #              na URL, validado previamente pelo before_action
  #              +validar_token_via_url+.
  # Retorno:
  # - Nenhum (apenas renderiza a view correspondente).
  # Efeitos colaterais:
  # - Nenhum além da renderização da view padrão.
  def cadastrar
  end

  ##
  # Exibe o formulário de solicitação de redefinição de senha.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - Nenhum (apenas renderiza a view correspondente).
  # Efeitos colaterais:
  # - Nenhum além da renderização da view padrão.
  def solicitar_redef_senha
  end

  ##
  # Exibe o formulário de redefinição de senha, acessado a partir do link
  # enviado por e-mail.
  #
  # Argumentos:
  # - Nenhum diretamente; depende do +params[:token]+ presente
  #              na URL, validado previamente pelo before_action
  #              +validar_token_via_url+.
  # Retorno:
  # - Nenhum (apenas renderiza a view correspondente).
  # Efeitos colaterais:
  # - Nenhum além da renderização da view padrão.
  def redefinir_senha
  end

  ##
  # Encerra a sessão do usuário atualmente autenticado.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - O resultado de +redirect_to+ (não utilizado pelo chamador).
  # Efeitos colaterais:
  # - Limpa toda a sessão (+session.clear+), zera a
  #                      variável de instância +@current_user+ e redireciona
  #                      para a página inicial com uma flash de sucesso.
  def logout
    session.clear
    @current_user = nil

    redirect_to root_path, flash: { success: "Sessão encerrada com sucesso." }
  end

  ##
  # Autentica um usuário a partir de matrícula/e-mail e senha enviados via
  # +params[:identificador]+ e +params[:senha]+.
  #
  # Argumentos:
  # - +identificador+: matrícula ou e-mail do usuário.
  # - +senha+: senha em texto puro a ser validada.
  # - Usa os valores recebidos via +params+.
  #
  # Retorno:
  # - O resultado do +redirect_to+ correspondente ao caminho que
  #   foi seguido.
  # - Possui múltiplos caminhos possíveis: campos inválidos, usuário
  #   inexistente, conta inativa, login bem sucedido ou senha incorreta.
  #
  # Efeitos colaterais:
  # - Em caso de sucesso, grava +usuario.id+ em
  #   +session[:usuario_id]+, autenticando o usuário.
  # - Em todos os casos redireciona o navegador e define uma mensagem flash.
  def login
    return redirecionar_erro_login if campos_login_invalidos?

    usuario = buscar_usuario_por_identificador(params[:identificador])
    return redirecionar_login_invalido if usuario_invalido?(usuario)
    return redirecionar_conta_inativa if conta_inativa?(usuario)
    return redirecionar_login_sucesso(usuario) if senha_valida?(usuario)

    redirecionar_senha_incorreta
  end

  ##
  # Processa a solicitação de cadastro (primeiro acesso) de um usuário,
  # validando o e-mail informado e disparando o e-mail de confirmação com
  # o token de cadastro.
  #
  # Argumentos:
  # - +email+: e-mail informado pelo usuário, deve corresponder ao e-mail
  #   institucional já cadastrado para a matrícula.
  # - +matricula+: matrícula institucional do usuário.
  # - Usa os valores recebidos via +params+.
  #
  # Retorno:
  # - O resultado do +redirect_to+ correspondente ao caminho seguido.
  # - Possui múltiplos caminhos possíveis: e-mail inválido, matrícula/e-mail
  #   não correspondem, e-mail enviado com sucesso ou falha técnica no envio.
  #
  # Efeitos colaterais:
  # - Cria um novo registro de Token associado ao usuário.
  # - Envia um e-mail de cadastro via +enviar_email_cadastro+.
  # - Redireciona e define mensagem flash.
  def processar_solicitacao_cadastro
    return redirecionar_erro_email_cadastro_invalido unless email_valido?(params[:email])

    usuario = Usuario.find_by(matricula: params[:matricula])
    return redirecionar_validacao_solicitacao_cadastro(usuario) if validacao_solicitacao_cadastro?(usuario)

    token_gerado = criar_token_cadastro(usuario)
    return redirecionar_sucesso_email_cadastro if enviar_email_cadastro(usuario.email, token_gerado)

    redirecionar_erro_email_cadastro
  end

  ##
  # Confirma o cadastro de um usuário, definindo sua senha e ativando a
  # conta. É um atalho que delega para +processar_confirmacao_senha+
  # informando o tipo de operação "cadastro".
  #
  # Argumentos:
  # - Nenhum diretamente; utiliza +params[:token]+,
  #              +params[:senha]+ e +params[:senha_confirmacao]+.
  # Retorno:
  # - O retorno de +processar_confirmacao_senha+ (redirecionamento).
  # Efeitos colaterais:
  # - Veja +processar_confirmacao_senha+.
  def confirmar_cadastro
    processar_confirmacao_senha("cadastro")
  end

  ##
  # Processa a solicitação de redefinição de senha de um usuário já
  # cadastrado, disparando o e-mail com o token de redefinição. É um
  # atalho que delega para +processar_solicitacao_redefinicao_senha+.
  #
  # Argumentos:
  # - Nenhum diretamente; utiliza +params[:email]+.
  # Retorno:
  # - O retorno de +processar_solicitacao_redefinicao_senha+.
  # Efeitos colaterais:
  # - Veja +processar_solicitacao_redefinicao_senha+.
  def processar_redefinicao_senha
    processar_solicitacao_redefinicao_senha
  end

  ##
  # Confirma a redefinição de senha de um usuário. É um atalho que delega
  # para +processar_confirmacao_senha+ informando o tipo de operação
  # "redefinicao".
  #
  # Argumentos:
  # - Nenhum diretamente; utiliza +params[:token]+,
  #              +params[:senha]+ e +params[:senha_confirmacao]+.
  # Retorno:
  # - O retorno de +processar_confirmacao_senha+ (redirecionamento).
  # Efeitos colaterais:
  # - Veja +processar_confirmacao_senha+.
  def confirmar_redefinicao_senha
    processar_confirmacao_senha("redefinicao")
  end

  private

  ##
  # Verifica se os campos obrigatórios do formulário de login foram
  # preenchidos.
  #
  # Argumentos:
  # - Nenhum diretamente; utiliza +params[:identificador]+ e
  #              +params[:senha]+.
  # Retorno:
  # - +true+ se +identificador+ ou +senha+ estiverem em branco,
  #           +false+ caso contrário.
  # Efeitos colaterais:
  # - Nenhum.
  def campos_login_invalidos?
    params[:identificador].blank? || params[:senha].blank?
  end

  ##
  # Monta a mensagem de erro apropriada para campos de login inválidos e
  # redireciona o usuário de volta à página inicial.
  #
  # Argumentos:
  # - Nenhum diretamente; utiliza +params[:identificador]+ e
  #              +params[:senha]+ para decidir qual mensagem exibir.
  # Retorno:
  # - O resultado de +redirect_to+ (via +redirecionar_com_erro+).
  # Efeitos colaterais:
  # - Redireciona para a página inicial com uma flash
  #                      de erro.
  def redirecionar_erro_login
    mensagem = if params[:identificador].blank? && params[:senha].blank?
                 "Informe sua matrícula ou e-mail e sua senha."
    elsif params[:identificador].blank?
                 "Informe sua matrícula ou e-mail."
    else
                 "Informe sua senha."
    end

    redirecionar_com_erro(root_path, mensagem)
  end

  ##
  # Verifica se um usuário não foi encontrado.
  #
  # Argumentos:
  # - +usuario+: instância de Usuario (ou +nil+) a ser
  #              verificada.
  # Retorno:
  # - +true+ se +usuario+ for +nil+, +false+ caso contrário.
  # Efeitos colaterais:
  # - Nenhum.
  def usuario_invalido?(usuario)
    usuario.nil?
  end

  ##
  # Verifica se a conta do usuário ainda não foi ativada.
  #
  # Argumentos:
  # - +usuario+: instância de Usuario a ser verificada.
  # Retorno:
  # - +true+ se a conta não estiver ativa, +false+ caso contrário.
  # Efeitos colaterais:
  # - Nenhum.
  def conta_inativa?(usuario)
    !usuario.ativo?
  end

  ##
  # Verifica se a senha informada no login corresponde à senha do usuário.
  #
  # Argumentos:
  # - +usuario+: instância de Usuario cuja senha será
  #              validada; utiliza também +params[:senha]+.
  # Retorno:
  # - +true+ se a senha informada estiver correta, +false+ caso
  #           contrário.
  # Efeitos colaterais:
  # - Nenhum.
  def senha_valida?(usuario)
    usuario.authenticate_senha(params[:senha])
  end

  ##
  # Redireciona para a página inicial informando que a matrícula ou
  # e-mail informado é inválido.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - O resultado de +redirect_to+.
  # Efeitos colaterais:
  # - Redireciona para a página inicial com flash de
  #                      erro.
  def redirecionar_login_invalido
    redirect_to root_path, flash: { error: "Matrícula ou e-mail inválido." }
  end

  ##
  # Redireciona para a página inicial informando que a conta ainda não
  # foi ativada.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - O resultado de +redirect_to+.
  # Efeitos colaterais:
  # - Redireciona para a página inicial com flash de
  #                      erro.
  def redirecionar_conta_inativa
    redirect_to root_path,
      flash: { error: "Esta conta ainda não foi ativada. Por favor, realize o Primeiro Acesso." }
  end

  ##
  # Efetiva o login do usuário na sessão e redireciona para a área
  # autenticada do sistema.
  #
  # Argumentos:
  # - +usuario+: instância de Usuario que acabou de ser
  #              autenticada.
  # Retorno:
  # - O resultado de +redirect_to+.
  # Efeitos colaterais:
  # - Grava +usuario.id+ em +session[:usuario_id]+
  #                      (efetivando a autenticação) e redireciona para a
  #                      página de avaliações com flash de sucesso.
  def redirecionar_login_sucesso(usuario)
    session[:usuario_id] = usuario.id
    redirect_to avaliacoes_path, flash: { success: "Login realizado com sucesso! Seja bem-vindo." }
  end

  ##
  # Redireciona para a página inicial informando que a senha informada
  # está incorreta.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - O resultado de +redirect_to+.
  # Efeitos colaterais:
  # - Redireciona para a página inicial com flash de
  #                      erro.
  def redirecionar_senha_incorreta
    redirect_to root_path, flash: { error: "Senha incorreta." }
  end

  ##
  # Redireciona de volta ao formulário de cadastro informando que o
  # e-mail possui formato inválido.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - O resultado de +redirect_to+ (via +redirecionar_com_erro+).
  # Efeitos colaterais:
  # - Redireciona para a página de cadastro com flash
  #                      de erro.
  def redirecionar_erro_email_cadastro_invalido
    redirecionar_com_erro(cadastro_path, "Por favor, insira um formato de e-mail válido.")
  end

  ##
  # Redireciona de volta ao formulário de cadastro informando que a
  # matrícula não foi encontrada no sistema institucional.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - O resultado de +redirect_to+ (via +redirecionar_com_erro+).
  # Efeitos colaterais:
  # - Redireciona para a página de cadastro com flash
  #                      de erro.
  def redirecionar_matricula_inexistente
    redirecionar_com_erro(cadastro_path, "Matrícula não encontrada no sistema institucional.")
  end

  ##
  # Redireciona de volta ao formulário de cadastro informando que o
  # e-mail informado não corresponde ao e-mail institucional cadastrado
  # para a matrícula.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - O resultado de +redirect_to+ (via +redirecionar_com_erro+).
  # Efeitos colaterais:
  # - Redireciona para a página de cadastro com flash
  #                      de erro.
  def redirecionar_email_institucional_incorreto
    redirecionar_com_erro(
      cadastro_path,
      "O e-mail informado não corresponde ao e-mail institucional desta matrícula."
    )
  end

  ##
  # Redireciona de volta ao formulário de cadastro informando que a
  # matrícula já possui um cadastro ativo.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - O resultado de +redirect_to+ (via +redirecionar_com_erro+).
  # Efeitos colaterais:
  # - Redireciona para a página de cadastro com flash
  #                      de erro.
  def redirecionar_matricula_ativa
    redirecionar_com_erro(
      cadastro_path,
      "Esta matrícula já possui um cadastro ativo. Caso tenha esquecido sua senha, utilize a redefinição."
    )
  end

  ##
  # Verifica se a solicitação de cadastro é inválida, seja por usuário
  # inexistente, e-mail divergente do institucional, ou conta já ativa.
  #
  # Argumentos:
  # - +usuario+: instância de Usuario (ou +nil+) encontrada
  #              pela matrícula informada.
  # Retorno:
  # - +true+ se a solicitação de cadastro deve ser recusada,
  #           +false+ caso possa prosseguir.
  # Efeitos colaterais:
  # - Nenhum.
  def validacao_solicitacao_cadastro?(usuario)
    usuario_invalido?(usuario) || !email_corresponde_ao_institucional?(usuario) || !conta_inativa?(usuario)
  end

  ##
  # Decide para qual mensagem de erro redirecionar quando a solicitação
  # de cadastro é inválida, de acordo com o motivo específico (usuário
  # inexistente, e-mail divergente ou matrícula já ativa).
  #
  # Argumentos:
  # - +usuario+: instância de Usuario (ou +nil+) encontrada
  #              pela matrícula informada.
  # Retorno:
  # - O resultado de um dos métodos de redirecionamento de erro
  #           (+redirecionar_matricula_inexistente+,
  #           +redirecionar_email_institucional_incorreto+ ou
  #           +redirecionar_matricula_ativa+). Possui, portanto, três
  #           caminhos de retorno possíveis.
  # Efeitos colaterais:
  # - Redireciona o navegador com flash de erro
  #                      (efeito herdado do método chamado).
  def redirecionar_validacao_solicitacao_cadastro(usuario)
    return redirecionar_matricula_inexistente if usuario_invalido?(usuario)
    return redirecionar_email_institucional_incorreto unless email_corresponde_ao_institucional?(usuario)

    redirecionar_matricula_ativa
  end

  ##
  # Verifica se a senha e a confirmação de senha informadas nos
  # formulários de cadastro/redefinição são válidas (preenchidas, com
  # tamanho mínimo e idênticas entre si).
  #
  # Argumentos:
  # - Nenhum diretamente; utiliza +params[:senha]+ e
  #              +params[:senha_confirmacao]+.
  # Retorno:
  # - +true+ se a senha for válida e coincidir com a confirmação,
  #           +false+ caso contrário.
  # Efeitos colaterais:
  # - Nenhum.
  def senha_confirmacao_valida?
    return false if params[:senha].blank? || params[:senha_confirmacao].blank?
    return false if params[:senha].length < TAMANHO_MINIMO_SENHA

    params[:senha] == params[:senha_confirmacao]
  end

  ##
  # Processa a confirmação de senha tanto para o fluxo de cadastro quanto
  # para o de redefinição de senha, validando o token, atualizando a
  # senha do usuário e concluindo a operação.
  #
  # Argumentos:
  # - +tipo_operacao+: String, "cadastro" ou "redefinicao",
  #              indicando qual fluxo está sendo processado.
  # Retorno:
  # - O resultado de um redirecionamento (sucesso ou erro).
  #           Possui múltiplos caminhos possíveis: senha/confirmação
  #           inválidas, token inválido/expirado, falha ao salvar o
  #           usuário, ou conclusão bem-sucedida.
  # Efeitos colaterais:
  # - Atualiza a senha (e, em caso de cadastro, o
  #                      status) do usuário no banco de dados; em caso de
  #                      sucesso, destrói o registro de Token utilizado.
  #                      Redireciona o navegador e define mensagem flash.
  def processar_confirmacao_senha(tipo_operacao)
    return redirecionar_erro_confirmacao_senha(tipo_operacao) unless senha_confirmacao_valida?

    token_registro = buscar_token_valido(params[:token], tipo_operacao)
    return redirecionar_token_invalido(tipo_operacao) if token_registro.nil?

    usuario = token_registro.usuario
    preparar_usuario_para_confirmacao(usuario, tipo_operacao)
    return concluir_confirmacao(usuario, token_registro, tipo_operacao) if usuario.save

    redirecionar_erro_salvamento_confirmacao(usuario, tipo_operacao)
  end

  ##
  # Processa a solicitação de redefinição de senha, validando o e-mail
  # informado e disparando o e-mail com o token de redefinição.
  #
  # Argumentos:
  # - Nenhum diretamente; utiliza +params[:email]+.
  # Retorno:
  # - O resultado de um redirecionamento. Possui múltiplos
  #           caminhos possíveis: e-mail inválido, e-mail não cadastrado,
  #           envio com sucesso ou falha técnica no envio.
  # Efeitos colaterais:
  # - Cria um novo registro de Token associado ao
  #                      usuário (gravação no banco de dados) e envia um
  #                      e-mail de redefinição via
  #                      +enviar_email_redefinicao+. Redireciona o
  #                      navegador e define mensagem flash.
  def processar_solicitacao_redefinicao_senha
    return erro_solicitacao_redefinicao_senha unless email_valido?(params[:email])

    usuario = Usuario.find_by(email: params[:email])
    return erro_email_nao_cadastrado if usuario.nil?

    token_gerado = criar_token_redefinicao(usuario)
    return redirecionar_sucesso_redefinicao_senha if enviar_email_redefinicao(params[:email], token_gerado)

    redirecionar_erro_redefinicao_senha
  end

  ##
  # Atribui ao usuário a nova senha informada e, quando o fluxo for de
  # cadastro, ativa sua conta.
  #
  # Argumentos:
  # - +usuario+: instância de Usuario a ser preparada.
  # - +tipo_operacao+: String, "cadastro" ou "redefinicao".
  # Retorno:
  # - Nenhum valor relevante (sempre retorna o resultado da
  #           última atribuição/condicional).
  # Efeitos colaterais:
  # - Altera os atributos +senha+, +senha_confirmation+
  #                      e, se aplicável, +status+ do objeto +usuario+ em
  #                      memória (a gravação no banco ocorre apenas
  #                      quando +usuario.save+ for chamado pelo método
  #                      que invoca este).
  def preparar_usuario_para_confirmacao(usuario, tipo_operacao)
    usuario.senha = params[:senha]
    usuario.senha_confirmation = params[:senha_confirmacao]
    return unless tipo_operacao == "cadastro"

    usuario.status = :ativo
  end

  ##
  # Finaliza com sucesso o fluxo de cadastro ou redefinição de senha,
  # descartando o token utilizado e redirecionando o usuário para a
  # página de login.
  #
  # Argumentos:
  # - +usuario+: instância de Usuario que teve a senha confirmada (não
  #   utilizado diretamente no corpo do método).
  # - +token_registro+: instância de Token a ser destruída.
  # - +tipo_operacao+: String, "cadastro" ou "redefinicao", usada para
  #   decidir a mensagem de sucesso exibida.
  # Retorno:
  # - O resultado de +redirect_to+. Possui duas mensagens de
  #           sucesso possíveis, de acordo com +tipo_operacao+.
  # Efeitos colaterais:
  # - Remove o registro de Token do banco de dados
  #                      (+token_registro.destroy+) e redireciona o
  #                      navegador para a página inicial com flash de
  #                      sucesso.
  def concluir_confirmacao(usuario, token_registro, tipo_operacao)
    token_registro.destroy
    return redirect_to root_path, flash: { success: "Cadastro concluído com sucesso! Faça seu login." } if tipo_operacao == "cadastro"

    redirect_to root_path,
      flash: { success: "Sua senha foi alterada com sucesso! Insira suas novas credenciais para acessar." }
  end

  ##
  # Redireciona de volta ao formulário de confirmação de senha (cadastro
  # ou redefinição) quando o usuário não pôde ser salvo, exibindo as
  # mensagens de erro de validação do model.
  #
  # Argumentos:
  # - +usuario+: instância de Usuario que falhou ao ser salva, contendo
  #   os erros de validação em +usuario.errors+.
  # - +tipo_operacao+: String, "cadastro" ou "redefinicao".
  # Retorno:
  # - O resultado de +redirect_to+. Possui dois destinos
  #           possíveis (confirmação de cadastro ou de redefinição), de
  #           acordo com +tipo_operacao+.
  # Efeitos colaterais:
  # - Redireciona o navegador de volta ao formulário
  #                      correspondente, com flash de erro contendo as
  #                      mensagens de validação do usuário. Não realiza
  #                      nenhuma alteração no banco de dados.
  def redirecionar_erro_salvamento_confirmacao(usuario, tipo_operacao)
    return redirect_to confirmar_cadastro_path(token: params[:token]),
      flash: { error: usuario.errors.full_messages.to_sentence } if tipo_operacao == "cadastro"

    redirect_to redefinir_senha_path(token: params[:token]),
      flash: { error: usuario.errors.full_messages.to_sentence }
  end

  ##
  # Redireciona de volta ao formulário de confirmação de senha quando os
  # campos de senha/confirmação são inválidos, exibindo a mensagem de
  # erro mais específica possível (campos em branco, senha curta ou
  # senhas que não coincidem).
  #
  # Argumentos:
  # - +tipo_operacao+: String, "cadastro" ou "redefinicao".
  # Retorno:
  # - O resultado de +redirect_to+ (via +redirecionar_com_erro+).
  #           Possui três mensagens de erro possíveis.
  # Efeitos colaterais:
  # - Redireciona o navegador de volta ao formulário
  #                      correspondente com flash de erro.
  def redirecionar_erro_confirmacao_senha(tipo_operacao)
    if params[:senha].blank? || params[:senha_confirmacao].blank?
      return redirecionar_com_erro(
        caminho_confirmacao_senha(tipo_operacao),
        "Os campos de senha são obrigatórios."
      )
    end

    if params[:senha].length < TAMANHO_MINIMO_SENHA
      return redirecionar_com_erro(
        caminho_confirmacao_senha(tipo_operacao),
        mensagem_senha_curta(tipo_operacao)
      )
    end

    redirecionar_com_erro(
      caminho_confirmacao_senha(tipo_operacao),
      "As senhas não coincidem. Digite novamente."
    )
  end

  ##
  # Determina o caminho (rota) do formulário de confirmação de senha de
  # acordo com o tipo de operação em andamento.
  #
  # Argumentos:
  # - +tipo_operacao+: String, "cadastro" ou "redefinicao".
  # Retorno:
  # - String com a URL gerada por +redefinir_senha_path+ ou
  #           +confirmar_cadastro_path+, incluindo +params[:token]+.
  # Efeitos colaterais:
  # - Nenhum.
  def caminho_confirmacao_senha(tipo_operacao)
    return redefinir_senha_path(token: params[:token]) if tipo_operacao == "redefinicao"

    confirmar_cadastro_path(token: params[:token])
  end

  ##
  # Monta a mensagem de erro exibida quando a senha informada não atende
  # ao tamanho mínimo exigido, com texto adaptado ao tipo de operação.
  #
  # Argumentos:
  # - +tipo_operacao+: String, "cadastro" ou "redefinicao".
  # Retorno:
  # - String com a mensagem de erro correspondente.
  # Efeitos colaterais:
  # - Nenhum.
  def mensagem_senha_curta(tipo_operacao)
    return "A nova senha deve conter pelo menos #{TAMANHO_MINIMO_SENHA} caracteres." if tipo_operacao == "redefinicao"

    "A senha deve conter pelo menos #{TAMANHO_MINIMO_SENHA} caracteres."
  end

  ##
  # Redireciona para a página inicial informando que o token de
  # cadastro/redefinição é inválido, expirado ou não corresponde à
  # operação solicitada.
  #
  # Argumentos:
  # - +tipo_operacao+: String, "cadastro" ou "redefinicao",
  #              usada para adaptar o texto da mensagem.
  # Retorno:
  # - O resultado de +redirect_to+ (via +redirecionar_com_erro+).
  # Efeitos colaterais:
  # - Redireciona o navegador para a página inicial
  #                      com flash de erro.
  def redirecionar_token_invalido(tipo_operacao)
    mensagem = if tipo_operacao == "redefinicao"
                 "O link de redefinição é inválido, expirou ou não corresponde a esta operação."
    else
                 "O link de confirmação é inválido, expirou ou não corresponde a esta operação."
    end

    redirecionar_com_erro(root_path, mensagem)
  end

  ##
  # Finaliza o fluxo de cadastro descartando o token utilizado e
  # redirecionando o usuário para a página de login.
  #
  # NOTA: método atualmente não referenciado por nenhum fluxo ativo do
  # controlador (mantido sem alteração de comportamento).
  #
  # Argumentos:
  # - +usuario+: instância de Usuario (não utilizado diretamente no
  #   corpo do método).
  # - +token_registro+: instância de Token a ser destruída.
  # Retorno:
  # - O resultado de +redirect_to+.
  # Efeitos colaterais:
  # - Remove o registro de Token do banco de dados e
  #                      redireciona o navegador para a página inicial
  #                      com flash de sucesso.
  def concluir_cadastro(usuario, token_registro)
    token_registro.destroy
    redirect_to root_path, flash: { success: "Cadastro concluído com sucesso! Faça seu login." }
  end

  ##
  # Redireciona de volta ao formulário de confirmação de cadastro quando
  # o usuário não pôde ser salvo, exibindo as mensagens de erro de
  # validação do model.
  #
  # NOTA: método atualmente não referenciado por nenhum fluxo ativo do
  # controlador (mantido sem alteração de comportamento).
  #
  # Argumentos:
  # - +usuario+: instância de Usuario que falhou ao ser
  #              salva, contendo os erros de validação em
  #              +usuario.errors+.
  # Retorno:
  # - O resultado de +redirect_to+.
  # Efeitos colaterais:
  # - Redireciona o navegador de volta ao formulário
  #                      de confirmação de cadastro, com flash de erro
  #                      contendo as mensagens de validação do usuário.
  def redirecionar_erro_salvamento_cadastro(usuario)
    redirect_to confirmar_cadastro_path(token: params[:token]),
      flash: { error: usuario.errors.full_messages.to_sentence }
  end

  ##
  # Gera e persiste um token de redefinição de senha para o usuário
  # informado, com validade de 10 minutos.
  #
  # Argumentos:
  # - +usuario+: instância de Usuario para a qual o token
  #              será criado.
  # Retorno:
  # - String contendo o valor (hexadecimal) do token gerado.
  # Efeitos colaterais:
  # - Delega a criação do Token associado ao usuário
  #                      para +Auth::TokenIssuer+.
  def criar_token_redefinicao(usuario)
    Auth::TokenIssuer.call(usuario: usuario, tipo: "redefinicao")
  end

  ##
  # Redireciona de volta ao formulário de solicitação de redefinição de
  # senha informando que o e-mail possui formato inválido.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - O resultado de +redirect_to+ (via +redirecionar_com_erro+).
  # Efeitos colaterais:
  # - Redireciona o navegador com flash de erro.
  def erro_solicitacao_redefinicao_senha
    redirecionar_com_erro(solicitar_redef_senha_path, "Por favor, insira um formato de e-mail válido.")
  end

  ##
  # Redireciona de volta ao formulário de solicitação de redefinição de
  # senha informando que o e-mail não está cadastrado no sistema.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - O resultado de +redirect_to+ (via +redirecionar_com_erro+).
  # Efeitos colaterais:
  # - Redireciona o navegador com flash de erro.
  def erro_email_nao_cadastrado
    redirecionar_com_erro(solicitar_redef_senha_path, "Este e-mail não está cadastrado no sistema.")
  end

  ##
  # Redireciona para a página inicial informando que o e-mail de
  # redefinição de senha foi enviado com sucesso.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - O resultado de +redirect_to+.
  # Efeitos colaterais:
  # - Redireciona o navegador para a página inicial
  #                      com flash de sucesso contendo HTML com o tempo
  #                      de validade do link.
  def redirecionar_sucesso_redefinicao_senha
    redirect_to root_path, flash: { success: mensagem_email_enviado("10 minutos") }
  end

  ##
  # Redireciona de volta ao formulário de solicitação de redefinição de
  # senha informando que houve um erro técnico ao enviar o e-mail.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - O resultado de +redirect_to+.
  # Efeitos colaterais:
  # - Redireciona o navegador com flash de erro.
  def redirecionar_erro_redefinicao_senha
    redirect_to solicitar_redef_senha_path,
      flash: { error: "Houve um erro técnico ao tentar enviar o e-mail de recuperação. Tente novamente mais tarde." }
  end

  ##
  # Finaliza o fluxo de redefinição de senha descartando o token
  # utilizado e redirecionando o usuário para a página de login.
  #
  # NOTA: método atualmente não referenciado por nenhum fluxo ativo do
  # controlador (mantido sem alteração de comportamento).
  #
  # Argumentos:
  # - +usuario+: instância de Usuario (não utilizado diretamente no
  #   corpo do método).
  # - +token_registro+: instância de Token a ser destruída.
  # Retorno:
  # - O resultado de +redirect_to+.
  # Efeitos colaterais:
  # - Remove o registro de Token do banco de dados e
  #                      redireciona o navegador para a página inicial
  #                      com flash de sucesso.
  def concluir_redefinicao_senha(usuario, token_registro)
    token_registro.destroy
    redirect_to root_path,
      flash: { success: "Sua senha foi alterada com sucesso! Insira suas novas credenciais para acessar." }
  end

  ##
  # Redireciona de volta ao formulário de redefinição de senha quando o
  # usuário não pôde ser salvo, exibindo as mensagens de erro de
  # validação do model.
  #
  # NOTA: método atualmente não referenciado por nenhum fluxo ativo do
  # controlador (mantido sem alteração de comportamento).
  #
  # Argumentos:
  # - +usuario+: instância de Usuario que falhou ao ser
  #              salva, contendo os erros de validação em
  #              +usuario.errors+.
  # Retorno:
  # - O resultado de +redirect_to+.
  # Efeitos colaterais:
  # - Redireciona o navegador de volta ao formulário
  #                      de redefinição de senha, com flash de erro
  #                      contendo as mensagens de validação do usuário.
  def redirecionar_erro_salvamento_redefinicao(usuario)
    redirect_to redefinir_senha_path(token: params[:token]),
      flash: { error: usuario.errors.full_messages.to_sentence }
  end

  ##
  # Verifica se o e-mail informado em +params[:email]+ corresponde ao
  # e-mail institucional já cadastrado para o usuário, ignorando caixa e
  # espaços em branco.
  #
  # Argumentos:
  # - +usuario+: instância de Usuario cujo e-mail será
  #              comparado.
  # Retorno:
  # - +true+ se os e-mails coincidirem (normalizados), +false+
  #           caso contrário.
  # Efeitos colaterais:
  # - Nenhum.
  def email_corresponde_ao_institucional?(usuario)
    usuario.email.to_s.downcase.strip == params[:email].to_s.downcase.strip
  end

  ##
  # Gera e persiste um token de cadastro para o usuário informado, com
  # validade de 10 minutos.
  #
  # Argumentos:
  # - +usuario+: instância de Usuario para a qual o token
  #              será criado.
  # Retorno:
  # - String contendo o valor (hexadecimal) do token gerado.
  # Efeitos colaterais:
  # - Delega a criação do Token associado ao usuário
  #                      para +Auth::TokenIssuer+.
  def criar_token_cadastro(usuario)
    Auth::TokenIssuer.call(usuario: usuario, tipo: "cadastro")
  end

  ##
  # Redireciona para a página inicial informando que o e-mail de
  # confirmação de cadastro foi enviado com sucesso.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - O resultado de +redirect_to+.
  # Efeitos colaterais:
  # - Redireciona o navegador para a página inicial
  #                      com flash de sucesso contendo HTML com o tempo
  #                      de validade do link.
  def redirecionar_sucesso_email_cadastro
    redirect_to root_path, flash: { success: mensagem_email_enviado("10 minutos") }
  end

  ##
  # Redireciona de volta ao formulário de cadastro informando que houve
  # um erro técnico ao enviar o e-mail de confirmação.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - O resultado de +redirect_to+.
  # Efeitos colaterais:
  # - Redireciona o navegador com flash de erro.
  def redirecionar_erro_email_cadastro
    redirect_to cadastro_path,
      flash: { error: "Houve um erro técnico ao tentar enviar o e-mail. Tente novamente mais tarde." }
  end

  ##
  # before_action que impede o acesso às actions de cadastro/login a
  # usuários que já estão autenticados em uma sessão.
  #
  # Argumentos:
  # - Nenhum diretamente; utiliza +current_user+.
  # Retorno:
  # - Não possui retorno relevante; quando há usuário logado a
  #           callback interrompe a execução com +return+, evitando que a
  #           action original seja executada.
  # Efeitos colaterais:
  # - Caso exista um usuário autenticado, redireciona
  #                      para a página de avaliações com flash de erro,
  #                      impedindo o processamento da action solicitada.
  def impedir_se_logado
    return unless current_user.present?

    redirect_to avaliacoes_path,
      flash: { error: "Você já está logado em outra sessão. Faça o logout antes de poder terminar essa ação." }
  end

  ##
  # before_action que valida o token recebido via URL (+params[:token]+)
  # antes de permitir o acesso aos formulários de confirmação de cadastro
  # ou de redefinição de senha.
  #
  # Argumentos:
  # - Nenhum diretamente; utiliza +params[:token]+ e
  #              +action_name+ para determinar o tipo de token esperado.
  # Retorno:
  # - Não possui retorno relevante (callback de before_action).
  # Efeitos colaterais:
  # - Caso o token seja inválido, inexistente ou
  #                      expirado, redireciona para a página inicial com
  #                      flash de erro, impedindo o processamento da
  #                      action solicitada.
  def validar_token_via_url
    tipo_esperado = action_name == "cadastrar" ? "cadastro" : "redefinicao"
    token = buscar_token_valido(params[:token], tipo_esperado)

    redirect_to root_path, flash: { error: "Token inválido ou expirado." } if token.nil?
  end

  ##
  # Localiza um usuário a partir de um identificador que pode ser tanto
  # uma matrícula quanto um e-mail.
  #
  # Argumentos:
  # - +identificador+: String com a matrícula ou o e-mail
  #              informado pelo usuário.
  # Retorno:
  # - Uma instância de Usuario, caso encontrada, ou +nil+ caso
  #           contrário.
  # Efeitos colaterais:
  # - Nenhum (apenas consulta ao banco de dados).
  def buscar_usuario_por_identificador(identificador)
    identificador = identificador.to_s.strip

    if email_valido?(identificador)
      Usuario.find_by(email: identificador)
    else
      Usuario.find_by(matricula: identificador)
    end
  end

  ##
  # Verifica se uma string corresponde a um e-mail em formato válido.
  #
  # Argumentos:
  # - +email+: String a ser validada (pode ser +nil+ ou em
  #              branco).
  # Retorno:
  # - +true+ se o valor estiver presente e corresponder ao
  #           formato esperado de e-mail, +false+ caso contrário.
  # Efeitos colaterais:
  # - Nenhum.
  def email_valido?(email)
    email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    email.present? && email.match?(email_regex)
  end

  ##
  # Busca um token pelo seu valor e tipo, garantindo que ele ainda esteja
  # dentro do prazo de validade.
  #
  # Argumentos:
  # - +valor+: String com o valor do token a ser buscado.
  # - +tipo_esperado+: String, "cadastro" ou "redefinicao", indicando o
  #   tipo de token esperado.
  # Retorno:
  # - A instância de Token encontrada e ainda válida, ou +nil+
  #           caso o token não exista ou já tenha expirado.
  # Efeitos colaterais:
  # - Nenhum (apenas consulta ao banco de dados).
  def buscar_token_valido(valor, tipo_esperado)
    token = Token.find_by(value: valor, tipo: tipo_esperado)
    return nil if token.nil? || token.expires_at < Time.current

    token
  end

  ##
  # Método utilitário que redireciona o navegador para um caminho
  # informado, definindo uma mensagem flash de erro.
  #
  # Argumentos:
  # - +caminho+: String/rota de destino do redirecionamento.
  # - +mensagem+: String com o texto da mensagem flash de erro.
  # Retorno:
  # - O resultado de +redirect_to+.
  # Efeitos colaterais:
  # - Redireciona o navegador para o caminho informado
  #                      e define +flash[:error]+.
  def redirecionar_com_erro(caminho, mensagem)
    redirect_to caminho, flash: { error: mensagem }
  end

  ##
  # Monta o trecho de HTML exibido na mensagem flash de sucesso quando um
  # e-mail (de cadastro ou de redefinição de senha) é enviado, incluindo
  # um aviso sobre o prazo de validade do link.
  #
  # Argumentos:
  # - +validade+: String descrevendo o prazo de validade do
  #              link (ex.: "10 minutos").
  # Retorno:
  # - String contendo o HTML da mensagem.
  # Efeitos colaterais:
  # - Nenhum.
  def mensagem_email_enviado(validade)
    <<~HTML
      E-mail enviado com sucesso! Caso não o veja na caixa de entrada, cheque sua caixa de spam.
      <p style="color: #856404; background-color: #fff3cd; border: 1px solid #ffeeba; border-radius: 4px; padding: 8px; font-size: 12px; text-align: center; margin-top: 10px; margin-bottom: 0; font-family: sans-serif;">
        ⚠️ O link enviado terá validade de <strong>#{validade}</strong>.
      </p>
    HTML
  end
end
