# frozen_string_literal: true

# Concern responsável por encapsular toda a integração com a API
# transacional de e-mails da Brevo (antigo Sendinblue).
#
# Fornece tanto os métodos de baixo nível para montar e disparar uma
# requisição HTTP para a API da Brevo (+chamar_api_brevo+ e auxiliares)
# quanto os métodos de alto nível usados pelo restante da aplicação para
# enviar e-mails específicos do fluxo de autenticação (cadastro,
# redefinição de senha e convite de administrador).
module BrevoEmailable
  extend ActiveSupport::Concern

  # URI base do endpoint de envio de e-mails transacionais da API da
  # Brevo.
  BREVO_API_URL = URI("https://api.brevo.com/v3/smtp/email")

  # Dados do remetente (nome e e-mail) utilizados em todos os e-mails
  # enviados por este concern.
  REMETENTE = { "name" => "CAMAAR Support", "email" => "rafaelsapienzapinheiro@gmail.com" }.freeze

  ##
  # Monta e dispara uma requisição HTTP POST para a API da Brevo com o
  # payload informado, tratando ausência de chave de API e erros
  # inesperados.
  #
  # Argumentos:
  # - +payload+: Hash com o corpo da requisição a ser enviado em JSON
  #   para a API da Brevo (remetente, destinatário, assunto e conteúdo
  #   HTML do e-mail).
  # - +contexto:+: String opcional usada apenas para identificar a
  #   origem da chamada nos logs (ex.: "Cadastro", "Redefinição de
  #   senha"). Valor padrão: string vazia.
  # Retorno:
  # - +true+ se o e-mail foi enviado com sucesso (resposta HTTP
  #           2xx); +false+ se a chave de API não estiver configurada,
  #           se a API retornar uma resposta de erro, ou se ocorrer
  #           qualquer exceção durante a chamada.
  # Efeitos colaterais:
  # - Realiza uma chamada HTTP externa para a API da
  #                      Brevo (efeito de rede) e grava mensagens de
  #                      log (+Rails.logger.info+/+error+) descrevendo o
  #                      resultado da operação. Não realiza alterações
  #                      no banco de dados.
  def chamar_api_brevo(payload, contexto: "")
    api_key = brevo_api_key
    return false unless brevo_api_key_configurada?(api_key, contexto)

    response = brevo_http.request(brevo_request(payload, api_key))
    brevo_response_sucesso?(response, contexto)
  rescue StandardError => e
    Rails.logger.error "[BREVO] #{contexto} — Erro inesperado: #{e.message}"
    false
  end

  ##
  # Obtém a chave de API da Brevo a partir das credenciais criptografadas
  # do Rails.
  #
  # NOTA: este método público é redefinido pela versão privada presente
  # no final do arquivo (que também considera a variável de ambiente
  # +BREVO_API_KEY+); por ser definido depois, é a versão privada que
  # efetivamente é executada em tempo de execução. Mantido aqui sem
  # alteração de comportamento.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - String com a chave de API configurada, ou +nil+ caso não
  #           exista nenhuma credencial cadastrada para +brevo.api_key+.
  # Efeitos colaterais:
  # - Nenhum.
  def brevo_api_key
    Rails.application.credentials.dig(:brevo, :api_key)
  end

  ##
  # Verifica se a chave de API da Brevo está configurada, registrando um
  # log de erro caso não esteja.
  #
  # Argumentos:
  # - +api_key+: String (ou +nil+) com a chave de API a ser verificada.
  # - +contexto+: String usada para identificar a origem da chamada na
  #   mensagem de log em caso de erro.
  # Retorno:
  # - +true+ se +api_key+ estiver presente, +false+ caso
  #           contrário.
  # Efeitos colaterais:
  # - Caso a chave não esteja configurada, grava uma
  #                      mensagem de log de erro (+Rails.logger.error+).
  def brevo_api_key_configurada?(api_key, contexto)
    return true if api_key.present?

    Rails.logger.error "[BREVO] #{contexto} — Token de API não configurado."
    false
  end

  ##
  # Monta o conjunto de cabeçalhos HTTP exigidos pela API da Brevo.
  #
  # Argumentos:
  # - +api_key+: String com a chave de API a ser enviada no
  #              cabeçalho de autenticação.
  # Retorno:
  # - Hash contendo os cabeçalhos +Accept+, +api-key+ e
  #           +Content-Type+.
  # Efeitos colaterais:
  # - Nenhum.
  def brevo_headers(api_key)
    {
      "Accept" => "application/json",
      "api-key" => api_key,
      "Content-Type" => "application/json"
    }
  end

  ##
  # Constrói o cliente HTTP configurado para se comunicar com a API da
  # Brevo via HTTPS.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - Instância de +Net::HTTP+ configurada com o host e a porta
  #           de +BREVO_API_URL+ e com +use_ssl+ habilitado.
  # Efeitos colaterais:
  # - Nenhum (apenas instancia o objeto; a conexão de
  #                      rede só ocorre quando a requisição é de fato
  #                      executada em +chamar_api_brevo+).
  def brevo_http
    Net::HTTP.new(BREVO_API_URL.host, BREVO_API_URL.port).tap do |http|
      http.use_ssl = true
    end
  end

  ##
  # Monta o objeto de requisição HTTP POST a ser enviado para a API da
  # Brevo, já com cabeçalhos e corpo (payload serializado em JSON)
  # definidos.
  #
  # Argumentos:
  # - +payload+: Hash a ser serializado em JSON e enviado como corpo da
  #   requisição.
  # - +api_key+: String com a chave de API usada para montar os
  #   cabeçalhos de autenticação.
  # Retorno:
  # - Instância de +Net::HTTP::Post+ pronta para ser executada.
  # Efeitos colaterais:
  # - Nenhum (apenas monta o objeto da requisição; o
  #                      envio efetivo ocorre em +chamar_api_brevo+).
  def brevo_request(payload, api_key)
    Net::HTTP::Post.new(BREVO_API_URL.path, brevo_headers(api_key)).tap do |request|
      request.body = payload.to_json
    end
  end

  ##
  # Avalia a resposta HTTP retornada pela API da Brevo, registrando o
  # resultado (sucesso ou falha) no log da aplicação.
  #
  # Argumentos:
  # - +response+: Objeto de resposta HTTP (+Net::HTTPResponse+)
  #   retornado pela chamada à API.
  # - +contexto+: String usada para identificar a origem da chamada na
  #   mensagem de log.
  # Retorno:
  # - +true+ se a resposta for uma instância de
  #           +Net::HTTPSuccess+ (status 2xx), +false+ caso contrário.
  # Efeitos colaterais:
  # - Grava uma mensagem de log (+info+ em caso de
  #                      sucesso, +error+ em caso de falha, incluindo o
  #                      código de status e o corpo da resposta).
  def brevo_response_sucesso?(response, contexto)
    if response.is_a?(Net::HTTPSuccess)
      Rails.logger.info "[BREVO] #{contexto} — E-mail enviado com sucesso."
      true
    else
      Rails.logger.error "[BREVO] #{contexto} — Falha. Código: #{response.code} | Resposta: #{response.body}"
      false
    end
  end

  ##
  # Monta e envia o e-mail de confirmação de cadastro (primeiro acesso),
  # contendo o link com o token para o usuário definir sua senha.
  #
  # Argumentos:
  # - +destinatario+: String com o e-mail do usuário que receberá a
  #   mensagem.
  # - +token+: String com o token de cadastro a ser incluído na URL de
  #   confirmação.
  # Retorno:
  # - +true+ se o e-mail foi enviado com sucesso, +false+ caso
  #           contrário (delegado a +chamar_api_brevo+).
  # Efeitos colaterais:
  # - Realiza uma chamada HTTP externa para a API da
  #                      Brevo (envio de e-mail) e grava mensagens de log
  #                      sobre o resultado. Não realiza alterações no
  #                      banco de dados.
  def enviar_email_cadastro(destinatario, token)
    url = "http://127.0.0.1:3000/cadastro/confirmar/?token=#{token}"

    payload = {
      "sender"      => REMETENTE,
      "to"          => [ { "email" => destinatario } ],
      "subject"     => "Link de cadastro do CAMAAR",
      "htmlContent" => <<~HTML
        <html>
        <body style="font-family: sans-serif; color: #333; line-height: 1.6;">
          <h2>Olá!</h2>
          <p>Seja bem-vindo(a) ao <strong>CAMAAR</strong>. Recebemos sua solicitação para realizar o primeiro acesso no sistema institucional.</p>
          <p>Para ativar sua conta e configurar sua senha de acesso com segurança, clique no botão abaixo:</p>
          <p style="margin: 25px 0;">
            <a href="#{url}" target="_blank" style="background-color: #28a745; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold;">
              Confirmar Cadastro e Criar Senha
            </a>
          </p>
          <p style="font-size: 13px; color: #666;">
            Se o botão não funcionar, copie e cole este endereço no seu navegador:<br>
            <strong>#{url}</strong>
          </p>
          <div style="margin-top: 30px; padding: 12px; background-color: #f8f9fa; border-left: 4px solid #ffc107; font-size: 13px;">
            ⚠️ <strong>Importante:</strong> Este link é válido por apenas 10 minutos.<br>
            Caso ele expire antes de você concluir a ação, basta acessar a página de cadastro do CAMAAR novamente para gerar um novo envio.
          </div>
        </body>
        </html>
      HTML
    }

    chamar_api_brevo(payload, contexto: "Cadastro")
  end

  ##
  # Monta e envia o e-mail de redefinição de senha, contendo o link com o
  # token para o usuário escolher uma nova senha.
  #
  # Argumentos:
  # - +destinatario+: String com o e-mail do usuário que receberá a
  #   mensagem.
  # - +token+: String com o token de redefinição a ser incluído na URL
  #   de confirmação.
  # Retorno:
  # - +true+ se o e-mail foi enviado com sucesso, +false+ caso
  #           contrário (delegado a +chamar_api_brevo+).
  # Efeitos colaterais:
  # - Realiza uma chamada HTTP externa para a API da
  #                      Brevo (envio de e-mail) e grava mensagens de log
  #                      sobre o resultado. Não realiza alterações no
  #                      banco de dados.
  def enviar_email_redefinicao(destinatario, token)
    url = "http://127.0.0.1:3000/redefinir-senha/confirmar/?token=#{token}"

    payload = {
      "sender"      => REMETENTE,
      "to"          => [ { "email" => destinatario } ],
      "subject"     => "Recuperação de Senha — CAMAAR",
      "htmlContent" => <<~HTML
        <html>
        <body style="font-family: sans-serif; color: #333; line-height: 1.6;">
          <h2>Olá!</h2>
          <p>Você solicitou a redefinição de senha para sua conta no sistema <strong>CAMAAR</strong>.</p>
          <p>Para escolher uma nova senha e restabelecer o seu acesso, clique no botão abaixo:</p>
          <p style="margin: 25px 0;">
            <a href="#{url}" target="_blank" style="background-color: #dc3545; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold;">
              Redefinir Minha Senha
            </a>
          </p>
          <p style="font-size: 13px; color: #666;">
            Se o botão não funcionar, copie e cole este endereço no seu navegador:<br>
            <strong>#{url}</strong>
          </p>
          <div style="margin-top: 30px; padding: 12px; background-color: #f8f9fa; border-left: 4px solid #dc3545; font-size: 13px;">
            ⚠️ <strong>Segurança:</strong> Este link é válido por apenas 10 minutos.<br>
            Se você não realizou essa solicitação, por favor, desconsidere este e-mail. Seus dados de acesso continuarão seguros e inalterados.
          </div>
        </body>
        </html>
      HTML
    }

    chamar_api_brevo(payload, contexto: "Redefinição de senha")
  end

  ##
  # Monta e envia o e-mail de convite de cadastro disparado por um
  # administrador para um novo usuário, contendo o link com o token para
  # definição de senha.
  #
  # Argumentos:
  # - +destinatario+: String com o e-mail do usuário convidado.
  # - +token+: String com o token de cadastro a ser incluído na URL de
  #   confirmação.
  # - +nome_admin+: String com o nome do administrador que está
  #   realizando o convite, exibido no assunto e no corpo do e-mail.
  # Retorno:
  # - +true+ se o e-mail foi enviado com sucesso, +false+ caso
  #           contrário (delegado a +chamar_api_brevo+).
  # Efeitos colaterais:
  # - Realiza uma chamada HTTP externa para a API da
  #                      Brevo (envio de e-mail) e grava mensagens de log
  #                      sobre o resultado. Não realiza alterações no
  #                      banco de dados.
  def enviar_email_convite_admin(destinatario, token, nome_admin)
    url = "http://127.0.0.1:3000/cadastro/confirmar/?token=#{token}"

    payload = {
      "sender"      => REMETENTE,
      "to"          => [ { "email" => destinatario } ],
      "subject"     => "Convite de Cadastro no CAMAAR — Administrador(a) #{nome_admin}",
      "htmlContent" => <<~HTML
        <html>
        <body style="font-family: sans-serif; color: #333; line-height: 1.6;">
          <h2>Olá!</h2>
          <p>O(A) Administrador(a) <strong>#{nome_admin}</strong> está te convidando para realizar o seu cadastro no sistema do <strong>CAMAAR</strong>.</p>
          <p>Para criar sua senha e ativar sua conta com segurança, clique no link abaixo:</p>
          <p style="margin: 25px 0;">
            <a href="#{url}" target="_blank" style="background-color: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold;">
              Confirmar Cadastro e Criar Senha
            </a>
          </p>
          <p style="font-size: 13px; color: #666;">
            Se o botão não funcionar, copie e cole este endereço no seu navegador:<br>
            <strong>#{url}</strong>
          </p>
          <div style="margin-top: 30px; padding: 12px; background-color: #f8f9fa; border-left: 4px solid #ffc107; font-size: 13px;">
            ⚠️ <strong>Importante:</strong> Este link é válido por apenas 10 minutos.<br>
            Caso ele expire, não se preocupe! Acesse a página inicial do CAMAAR, vá na seção de cadastro e informe seus dados para receber um novo link por e-mail instantaneamente.
          </div>
        </body>
        </html>
      HTML
    }
    chamar_api_brevo(payload, contexto: "Convite do Administrador")
  end

  private

  ##
  # Obtém a chave de API da Brevo, priorizando a variável de ambiente
  # +BREVO_API_KEY+ e, na ausência dela, recorrendo às credenciais
  # criptografadas do Rails. Esta é a versão efetivamente utilizada pela
  # aplicação, pois reabre/sobrescreve a definição pública de
  # +brevo_api_key+ declarada no início do módulo.
  #
  # Argumentos:
  # - Nenhum.
  # Retorno:
  # - String com a chave de API encontrada (da variável de
  #           ambiente ou das credenciais), ou +nil+ caso nenhuma das
  #           duas fontes possua um valor configurado, ou caso as
  #           credenciais não possam ser decifradas.
  # Efeitos colaterais:
  # - Nenhum (apenas leitura de variável de ambiente e
  #                      de credenciais; nenhuma gravação é realizada).
  def brevo_api_key
    ENV["BREVO_API_KEY"].presence || Rails.application.credentials.dig(:brevo, :api_key)
  rescue ActiveSupport::MessageEncryptor::InvalidMessage, ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end
end
