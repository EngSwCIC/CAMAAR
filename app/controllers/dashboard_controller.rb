# frozen_string_literal: true

# Controlador responsável pelo painel principal do sistema: exibição das
# avaliações pendentes na tela inicial, pesquisa e sugestões de busca
# (turmas, matérias, avaliações, templates e formulários), e pela área de
# gerenciamento restrita a administradores (envio de convites de cadastro
# e importação/sincronização de dados a partir do arquivo do SIGAA).
class DashboardController < ApplicationController
  before_action :verificar_usuario, only: %i[index pesquisar sugestoes]
  before_action :verificar_admin, only: %i[gerenciamento importar_dados enviar_solicitacoes]

  ##
  # Exibe a tela inicial do sistema, listando um resumo das avaliações
  # pendentes do usuário autenticado.
  #
  # Argumentos:
  # - Nenhum. Consome indiretamente o +current_user+ da sessão.
  #
  # Retorno:
  # - Renderiza a view +index+.
  # - Popula a variável de instância +@avaliacoes_pendentes+ (limitada a
  #   6 registros).
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura.
  # - *Redirecionamento*: bloqueia e redireciona caso o usuário não esteja
  #   autenticado (via +before_action :verificar_usuario+).
  def index
    @avaliacoes_pendentes = avaliacoes_do_usuario.limit(6)
  end

  ##
  # Processa a pesquisa disparada pela barra de busca, delegando para o
  # fluxo de pesquisa por turma (quando +turma_id+ é informado) ou por
  # termo livre.
  #
  # Argumentos:
  # - Consome +params[:q]+ (termo pesquisado), +params[:turma_id]+
  #   (opcional) e os parâmetros de filtro processados por
  #   +inicializar_pesquisa+.
  #
  # Retorno:
  # - Renderiza a view +pesquisar+ (implicitamente).
  # - Popula as variáveis de instância +@termo+, +@avaliacoes+,
  #   +@templates+, +@formularios+ e +@tipos_selecionados+.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, delegada a
  #   +pesquisar_por_turma+/+pesquisar_por_termo+.
  # - *Redirecionamento*: bloqueia e redireciona caso o usuário não esteja
  #   autenticado (via +before_action+). Interrompe a execução (sem
  #   pesquisar) caso o termo esteja em branco.
  def pesquisar
    inicializar_pesquisa

    return if @termo.blank?
    return pesquisar_por_turma if params[:turma_id].present?

    pesquisar_por_termo
  end

  ##
  # Exibe a tela de gerenciamento, restrita a administradores.
  #
  # Argumentos:
  # - Nenhum.
  #
  # Retorno:
  # - Renderiza a view +gerenciamento+.
  #
  # Efeitos colaterais:
  # - *Redirecionamento*: bloqueia e redireciona (limpando a sessão)
  #   caso o usuário não esteja autenticado ou não seja administrador
  #   (via +before_action :verificar_admin+).
  def gerenciamento
  end

  ##
  # Dispara o envio de e-mails de convite de cadastro para todos os
  # usuários (docentes e discentes) pendentes de ativação no departamento
  # do administrador autenticado.
  #
  # Argumentos:
  # - Nenhum diretamente. Consome +current_user.perfil_adm.departamento_id+.
  #
  # Retorno:
  # - Sempre redireciona para +gerenciamento_path+. Possui múltiplos
  #   caminhos possíveis: departamento não associado, nenhum usuário
  #   pendente, ou resultado (sucesso total/parcial) do envio dos
  #   convites.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: leitura dos usuários pendentes; escrita
  #   (criação de tokens de cadastro) delegada a
  #   +enviar_convites_pendentes+.
  # - *Rede*: dispara chamadas HTTP à API da Brevo (via
  #   +enviar_convites_pendentes+) para cada usuário pendente.
  # - *Redirecionamento*: sempre redireciona para +gerenciamento_path+
  #   com uma mensagem flash (sucesso, aviso ou erro) refletindo o
  #   resultado.
  def enviar_solicitacoes
    resultado = SIGAA::SendPendingInvitations.call(current_user: current_user)
    redirect_to gerenciamento_path, flash: flash_envio_solicitacoes(resultado)
  end

  ##
  # Importa e sincroniza os dados institucionais (matérias, turmas,
  # docentes e discentes) a partir do arquivo JSON exportado do SIGAA,
  # criando/atualizando os registros correspondentes e removendo os que
  # não constam mais no arquivo.
  #
  # Argumentos:
  # - Nenhum diretamente. Lê o arquivo indicado por
  #   +caminho_arquivo_sigaa+ (+db/usuarios_sigaa.json+).
  #
  # Retorno:
  # - Sempre redireciona para +gerenciamento_path+. Possui múltiplos
  #   caminhos possíveis: arquivo não encontrado, ou resultado
  #   (sucesso total/parcial) da importação.
  #
  # Efeitos colaterais:
  # - *Banco de Dados (Escrita)*: cria/atualiza/remove registros de
  #   Materia, Turma, Usuario, PerfilDocente, PerfilDiscente e
  #   ParticipacaoTurma, delegado às operações de importação e ao
  #   método +sincronizar_remocoes_sigaa+.
  # - *Sistema de Arquivos*: realiza a leitura do arquivo JSON de
  #   importação.
  # - *Redirecionamento*: sempre redireciona para +gerenciamento_path+
  #   com uma mensagem flash refletindo o resultado.
  def importar_dados
    resultado = SIGAA::ImportData.call(path: caminho_arquivo_sigaa)
    redirect_to gerenciamento_path, flash: flash_importacao_sigaa(resultado)
  end

  ##
  # Endpoint utilizado pela barra de busca para retornar, em formato
  # JSON, sugestões de resultados (turmas, matérias, avaliações,
  # templates e formulários) de acordo com o termo digitado.
  #
  # Argumentos:
  # - Consome +params[:q]+ (termo pesquisado) e os parâmetros de filtro
  #   processados por +tipos_selecionados+.
  #
  # Retorno:
  # - Renderiza uma resposta JSON: um array vazio caso o termo esteja em
  #   branco, ou o array de sugestões retornado por
  #   +sugestoes_do_termo+.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura.
  # - *Redirecionamento*: bloqueia e redireciona caso o usuário não
  #   esteja autenticado (via +before_action+).
  def sugestoes
    termo = params[:q].to_s.strip
    return render json: [] if termo.blank?

    render json: sugestoes_do_termo(termo)
  end

  private

  def caminho_arquivo_sigaa
    Rails.root.join("db", "usuarios_sigaa.json")
  end

  def flash_envio_solicitacoes(resultado)
    return { error: "Seu usuário não possui um departamento associado." } if resultado.missing_department?
    return { notice: "Não há usuários pendentes de cadastro (docentes ou discentes) neste departamento." } if resultado.empty?
    return { success: "Convites enviados com sucesso para os <strong>#{resultado.successes}</strong> usuários pendentes do departamento!" } if resultado.success?

    {
      error: "O envio foi concluído com instabilidades. Foram enviados #{resultado.successes} e-mails.",
      error_list: resultado.errors
    }
  end

  def flash_importacao_sigaa(resultado)
    return { error: resultado.message } if resultado.missing_file?
    return { success: resultado.message } if resultado.success?

    { error: resultado.message, error_list: resultado.errors }
  end

  ##
  # Inicializa as variáveis de instância utilizadas pela tela de
  # pesquisa, antes de decidir qual fluxo de busca (por turma ou por
  # termo) será executado.
  #
  # Argumentos:
  # - Consome +params[:q]+ e os parâmetros de filtro processados por
  #   +tipos_selecionados+.
  #
  # Retorno:
  # - Não possui retorno relevante utilizado pelo chamador.
  #
  # Efeitos colaterais:
  # - Popula as variáveis de instância +@termo+, +@avaliacoes+,
  #   +@templates+, +@formularios+ (inicializadas como relações
  #   vazias) e +@tipos_selecionados+. Nenhuma alteração no banco de
  #   dados.
  def inicializar_pesquisa
    @termo = params[:q].to_s.strip
    @avaliacoes = Avaliacao.none
    @templates = Template.none
    @formularios = Formulario.none
    @tipos_selecionados = tipos_selecionados
  end

  ##
  # Executa a pesquisa restrita a uma turma específica (informada via
  # +params[:turma_id]+), populando avaliações e, para administradores,
  # formulários da turma.
  #
  # Argumentos:
  # - Consome +params[:turma_id]+ e +@tipos_selecionados+.
  #
  # Retorno:
  # - Não possui retorno relevante utilizado pelo chamador.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, delegada a
  #   +avaliacoes_da_turma+/+formularios_da_turma+. Popula
  #   +@avaliacoes+ e, se aplicável, +@formularios+.
  def pesquisar_por_turma
    turma_id = params[:turma_id]
    @avaliacoes = avaliacoes_da_turma(turma_id) if tipo_selecionado?("avaliacoes")
    @formularios = formularios_da_turma(turma_id) if administrador_com_tipo?("formularios")
  end

  ##
  # Executa a pesquisa por termo livre, populando avaliações para
  # qualquer usuário e, adicionalmente, templates e formulários para
  # administradores.
  #
  # Argumentos:
  # - Consome +@termo+ (via +padrao_pesquisa+) e +@tipos_selecionados+.
  #
  # Retorno:
  # - Não possui retorno relevante utilizado pelo chamador; interrompe
  #   a execução (via +return+) após popular avaliações, caso o
  #   usuário não seja administrador.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, delegada a
  #   +pesquisar_avaliacoes+/+pesquisar_templates+/+pesquisar_formularios+.
  #   Popula +@avaliacoes+ e, se aplicável, +@templates+ e
  #   +@formularios+.
  def pesquisar_por_termo
    padrao = padrao_pesquisa
    @avaliacoes = pesquisar_avaliacoes(padrao) if tipo_selecionado?("avaliacoes")

    return unless current_user.administrador?

    @templates = pesquisar_templates(padrao) if tipo_selecionado?("templates")
    @formularios = pesquisar_formularios(padrao) if tipo_selecionado?("formularios")
  end

  ##
  # Monta o padrão utilizado nas cláusulas SQL +LIKE+ a partir do termo
  # de pesquisa atual, já sanitizado e em minúsculas.
  #
  # Argumentos:
  # - Nenhum diretamente. Utiliza +@termo+.
  #
  # Retorno:
  # - Retorna uma String no formato +"%termo%"+, com o termo sanitizado
  #   via +ActiveRecord::Base.sanitize_sql_like+.
  #
  # Efeitos colaterais:
  # - Nenhum.
  def padrao_pesquisa
    "%#{ActiveRecord::Base.sanitize_sql_like(@termo.downcase)}%"
  end

  ##
  # Verifica se um determinado tipo de resultado (ex.: "avaliacoes",
  # "templates", "formularios") está entre os tipos selecionados pelo
  # filtro de pesquisa atual.
  #
  # Argumentos:
  # - +tipo+: String com o identificador do tipo a ser verificado.
  #
  # Retorno:
  # - Retorna +true+ se o tipo estiver presente em
  #   +@tipos_selecionados+, +false+ caso contrário.
  #
  # Efeitos colaterais:
  # - Nenhum.
  def tipo_selecionado?(tipo)
    @tipos_selecionados.include?(tipo)
  end

  ##
  # Verifica se o usuário atual é administrador e se, ao mesmo tempo, o
  # tipo informado está selecionado no filtro de pesquisa.
  #
  # Argumentos:
  # - +tipo+: String com o identificador do tipo a ser verificado.
  #
  # Retorno:
  # - Retorna +true+ se +current_user.administrador?+ e o tipo estiver
  #   selecionado, +false+ caso contrário.
  #
  # Efeitos colaterais:
  # - Nenhum.
  def administrador_com_tipo?(tipo)
    current_user.administrador? && tipo_selecionado?(tipo)
  end

  ##
  # Monta a lista completa de sugestões de busca para o termo informado,
  # combinando sugestões básicas (turmas e matérias), de avaliações e,
  # quando aplicável, de itens restritos a administradores (templates e
  # formulários).
  #
  # Argumentos:
  # - +termo+: String com o termo de pesquisa (não sanitizado).
  #
  # Retorno:
  # - Retorna um Array de Hash, cada um representando uma sugestão
  #   (com chaves como +:tipo+, +:titulo+, +:subtitulo+ e +:url+,
  #   variáveis conforme o tipo de sugestão).
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, delegada aos métodos de
  #   sugestão individuais.
  def sugestoes_do_termo(termo)
    tipos = tipos_selecionados
    padrao = "%#{ActiveRecord::Base.sanitize_sql_like(termo.downcase)}%"

    sugestoes_basicas(termo, padrao, tipos) +
      sugestoes_avaliacoes(padrao, tipos) +
      sugestoes_administrador(padrao, tipos)
  end

  ##
  # Combina as sugestões de turmas e de matérias, disponíveis para
  # qualquer usuário autenticado.
  #
  # Argumentos:
  # - +termo+: String com o termo de pesquisa (não sanitizado, usado
  #   para a busca de turmas).
  # - +padrao+: String já no formato +"%termo%"+, sanitizada (usada
  #   para a busca de matérias).
  # - +tipos+: Array de String com os tipos de resultado atualmente
  #   selecionados (repassado para compor as URLs das sugestões).
  #
  # Retorno:
  # - Retorna um Array de Hash com as sugestões de turmas seguidas das
  #   sugestões de matérias.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, delegada a
  #   +sugestoes_turmas+/+sugestoes_materias+.
  def sugestoes_basicas(termo, padrao, tipos)
    sugestoes_turmas(termo, tipos) + sugestoes_materias(padrao, tipos)
  end

  ##
  # Busca até 3 turmas correspondentes ao termo informado e as
  # transforma em sugestões formatadas para exibição.
  #
  # Argumentos:
  # - +termo+: String com o termo de pesquisa (repassado a
  #   +pesquisar_turmas+).
  # - +tipos+: Array de String com os tipos de resultado atualmente
  #   selecionados (repassado para compor a URL de cada sugestão).
  #
  # Retorno:
  # - Retorna um Array de Hash (tipo "Turma"), cada um contendo
  #   +:tipo+, +:titulo+, +:subtitulo+, +:materia_codigo+,
  #   +:turma_codigo+ e +:url+.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, delegada a +pesquisar_turmas+.
  def sugestoes_turmas(termo, tipos)
    pesquisar_turmas(termo).limit(3).map do |turma|
      {
        tipo: "Turma",
        titulo: turma.materia.nome,
        subtitulo: nil,
        materia_codigo: turma.materia.codigo,
        turma_codigo: turma.codigo_exibicao,
        url: turma_suggestion_url(turma, tipos)
      }
    end
  end

  ##
  # Busca até 3 matérias correspondentes ao padrão informado e as
  # transforma em sugestões formatadas para exibição.
  #
  # Argumentos:
  # - +padrao+: String já no formato +"%termo%"+, sanitizada
  #   (repassada a +pesquisar_materias+).
  # - +tipos+: Array de String com os tipos de resultado atualmente
  #   selecionados (repassado para compor a URL de cada sugestão).
  #
  # Retorno:
  # - Retorna um Array de Hash (tipo "Matéria"), cada um contendo
  #   +:tipo+, +:titulo+, +:subtitulo+, +:materia_codigo+ e +:url+.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, delegada a +pesquisar_materias+.
  def sugestoes_materias(padrao, tipos)
    pesquisar_materias(padrao).limit(3).map do |materia|
      {
        tipo: "Matéria",
        titulo: materia.nome,
        subtitulo: nil,
        materia_codigo: materia.codigo,
        url: materia_suggestion_url(materia, tipos)
      }
    end
  end

  ##
  # Busca até 5 avaliações correspondentes ao padrão informado, caso o
  # tipo "avaliacoes" esteja selecionado, e as transforma em sugestões
  # formatadas para exibição.
  #
  # Argumentos:
  # - +padrao+: String já no formato +"%termo%"+, sanitizada
  #   (repassada a +pesquisar_avaliacoes+).
  # - +tipos+: Array de String com os tipos de resultado atualmente
  #   selecionados.
  #
  # Retorno:
  # - Retorna um Array de Hash (tipo "Avaliação"), ou um Array vazio
  #   caso "avaliacoes" não esteja entre os tipos selecionados.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, delegada a
  #   +pesquisar_avaliacoes+.
  def sugestoes_avaliacoes(padrao, tipos)
    return [] unless tipos.include?("avaliacoes")

    pesquisar_avaliacoes(padrao).limit(5).map do |avaliacao|
      sugestao_avaliacao(avaliacao)
    end
  end

  ##
  # Monta o Hash de sugestão formatado para uma única avaliação.
  #
  # Argumentos:
  # - +avaliacao+: instância de Avaliacao a ser formatada como
  #   sugestão.
  #
  # Retorno:
  # - Retorna um Hash com +:tipo+, +:titulo+, +:subtitulo+,
  #   +:materia_codigo+, +:turma_codigo+ e +:url+.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura (navegação pelas associações
  #   +formulario+, +turma+, +materia+ e +template+ da avaliação, que
  #   pode disparar consultas adicionais caso não estejam
  #   pré-carregadas).
  def sugestao_avaliacao(avaliacao)
    turma = avaliacao.formulario.turma

    {
      tipo: "Avaliação",
      titulo: avaliacao.formulario.template&.titulo || "Avaliação",
      subtitulo: turma.nome_exibicao,
      materia_codigo: turma.materia.codigo,
      turma_codigo: turma.codigo_exibicao,
      url: responder_avaliacao_path(avaliacao)
    }
  end

  ##
  # Combina as sugestões restritas a administradores (templates e
  # formulários), retornando uma lista vazia para usuários comuns.
  #
  # Argumentos:
  # - +padrao+: String já no formato +"%termo%"+, sanitizada
  #   (repassada aos métodos de sugestão).
  # - +tipos+: Array de String com os tipos de resultado atualmente
  #   selecionados.
  #
  # Retorno:
  # - Retorna um Array de Hash com as sugestões de templates seguidas
  #   das sugestões de formulários, ou um Array vazio caso
  #   +current_user+ não seja administrador.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, delegada a
  #   +sugestoes_templates+/+sugestoes_formularios+.
  def sugestoes_administrador(padrao, tipos)
    return [] unless current_user.administrador?

    sugestoes_templates(padrao, tipos) + sugestoes_formularios(padrao, tipos)
  end

  ##
  # Busca até 5 templates correspondentes ao padrão informado, caso o
  # tipo "templates" esteja selecionado, e os transforma em sugestões
  # formatadas para exibição.
  #
  # Argumentos:
  # - +padrao+: String já no formato +"%termo%"+, sanitizada
  #   (repassada a +pesquisar_templates+).
  # - +tipos+: Array de String com os tipos de resultado atualmente
  #   selecionados.
  #
  # Retorno:
  # - Retorna um Array de Hash (tipo "Template"), ou um Array vazio
  #   caso "templates" não esteja entre os tipos selecionados.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, delegada a
  #   +pesquisar_templates+ (que já aplica a política de acesso via
  #   +policy_scope+).
  def sugestoes_templates(padrao, tipos)
    return [] unless tipos.include?("templates")

    pesquisar_templates(padrao).limit(5).map do |template|
      {
        tipo: "Template",
        titulo: template.titulo,
        subtitulo: template.descricao.presence || "Sem descrição",
        url: template_path(template)
      }
    end
  end

  ##
  # Busca até 5 formulários correspondentes ao padrão informado, caso o
  # tipo "formularios" esteja selecionado, e os transforma em sugestões
  # formatadas para exibição.
  #
  # Argumentos:
  # - +padrao+: String já no formato +"%termo%"+, sanitizada
  #   (repassada a +pesquisar_formularios+).
  # - +tipos+: Array de String com os tipos de resultado atualmente
  #   selecionados.
  #
  # Retorno:
  # - Retorna um Array de Hash (tipo "Formulário"), ou um Array vazio
  #   caso "formularios" não esteja entre os tipos selecionados.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, delegada a
  #   +pesquisar_formularios+ (restrita ao departamento do
  #   administrador atual).
  def sugestoes_formularios(padrao, tipos)
    return [] unless tipos.include?("formularios")

    pesquisar_formularios(padrao).limit(5).map do |formulario|
      {
        tipo: "Formulário",
        titulo: formulario.template&.titulo || "Template removido",
        subtitulo: formulario.turma.nome_exibicao,
        materia_codigo: formulario.turma.materia.codigo,
        turma_codigo: formulario.turma.codigo_exibicao,
        url: formulario_path(formulario)
      }
    end
  end

  ##
  # Sem o filtro aberto, assume as 3 categorias. Com o filtro aberto, usa
  # exatamente o que está marcado. "sem_templates" força a exclusão mesmo
  # que "templates" venha marcado por algum motivo (defesa, não deveria
  # acontecer já que o checkbox fica desabilitado nesse caso).
  #
  # Determina, a partir dos parâmetros da requisição, quais tipos de
  # resultado (avaliações, templates, formulários) devem ser
  # considerados na pesquisa ou nas sugestões atuais.
  #
  # Argumentos:
  # - Nenhum diretamente. Utiliza +params[:filtro_ativo]+,
  #   +params[:tipos]+ e +params[:sem_templates]+.
  #
  # Retorno:
  # - Retorna um Array de String com os tipos selecionados (ex.:
  #   +%w[avaliacoes templates formularios]+, ou um subconjunto,
  #   possivelmente sem "templates").
  #
  # Efeitos colaterais:
  # - Nenhum.
  def tipos_selecionados
    tipos = if params[:filtro_ativo].present?
              Array(params[:tipos])
    else
              %w[avaliacoes templates formularios]
    end

    tipos -= [ "templates" ] if params[:sem_templates] == "1"
    tipos
  end

  ##
  # before_action que garante que apenas usuários autenticados possam
  # acessar as actions de índice, pesquisa e sugestões.
  #
  # Argumentos:
  # - Nenhum diretamente. Utiliza +current_user+.
  #
  # Retorno:
  # - Não possui retorno relevante (callback de before_action).
  #
  # Efeitos colaterais:
  # - *Redirecionamento*: caso não haja usuário autenticado, redireciona
  #   para a página inicial com flash de erro, impedindo o
  #   processamento da action solicitada.
  def verificar_usuario
    return if current_user.present?

    redirect_to root_path,
      flash: { error: "Acesso restrito. Por favor, faça login para continuar." }
  end

  ##
  # Monta a consulta base das avaliações pendentes do usuário
  # autenticado, com as associações necessárias pré-carregadas,
  # ordenadas da mais recente para a mais antiga.
  #
  # Argumentos:
  # - Nenhum diretamente. Utiliza +current_user.id+.
  #
  # Retorno:
  # - Retorna um +ActiveRecord::Relation+ de Avaliacao (ainda não
  #   executado), podendo ser encadeado com filtros adicionais pelos
  #   métodos chamadores.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, executada de forma lazy quando
  #   a relação for de fato utilizada.
  def avaliacoes_do_usuario
    Avaliacao
      .pendentes
      .joins(:participacao_turma)
      .where(participacoes_turmas: { usuario_id: current_user.id })
      .includes(formulario: [ :template, { turma: :materia } ])
      .order(created_at: :desc)
  end

  ##
  # Filtra as avaliações pendentes do usuário restritas a uma turma
  # específica.
  #
  # Argumentos:
  # - +turma_id+: ID da Turma pela qual as avaliações serão filtradas.
  #
  # Retorno:
  # - Retorna um +ActiveRecord::Relation+ de Avaliacao, filtrado pela
  #   turma informada.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, executada de forma lazy.
  def avaliacoes_da_turma(turma_id)
    avaliacoes_do_usuario
      .joins(:formulario)
      .where(formularios: { turma_id: turma_id })
  end

  ##
  # Busca os formulários mais recentes de uma turma específica dentro do
  # departamento do administrador autenticado.
  #
  # Argumentos:
  # - +turma_id+: ID da Turma pela qual os formulários serão
  #   filtrados.
  #
  # Retorno:
  # - Retorna um +ActiveRecord::Relation+ de Formulario, restrito ao
  #   departamento do administrador atual e à turma informada.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, executada de forma lazy.
  #   Consome +current_administrador.departamento+.
  def formularios_da_turma(turma_id)
    Formulario
      .do_departamento(current_administrador.departamento)
      .where(turma_id: turma_id)
      .includes(:template, turma: :materia)
      .recentes
  end

  ##
  # Filtra as avaliações pendentes do usuário cujo título do template,
  # nome ou código da matéria correspondam ao padrão de pesquisa.
  #
  # Argumentos:
  # - +padrao+: String já no formato +"%termo%"+, sanitizada.
  #
  # Retorno:
  # - Retorna um +ActiveRecord::Relation+ de Avaliacao filtrado pelo
  #   padrão informado.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, executada de forma lazy.
  def pesquisar_avaliacoes(padrao)
    avaliacoes_do_usuario
      .joins(formulario: [ :template, { turma: :materia } ])
      .where(
        "LOWER(templates.titulo) LIKE :padrao OR LOWER(materias.nome) LIKE :padrao OR LOWER(materias.codigo) LIKE :padrao",
        padrao: padrao
      )
  end

  ##
  # Busca os templates (restritos pela política de acesso do usuário
  # atual) cujo título ou descrição correspondam ao padrão de pesquisa.
  #
  # Argumentos:
  # - +padrao+: String já no formato +"%termo%"+, sanitizada.
  #
  # Retorno:
  # - Retorna um +ActiveRecord::Relation+ de Template, filtrado e
  #   ordenado pelos mais recentes.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, executada de forma lazy. Aplica
  #   +policy_scope(Template)+, que pode disparar verificações de
  #   autorização.
  def pesquisar_templates(padrao)
    policy_scope(Template)
      .where(
        "LOWER(templates.titulo) LIKE :padrao OR " \
          "LOWER(COALESCE(templates.descricao, '')) LIKE :padrao",
        padrao: padrao
      )
      .recentes
  end

  ##
  # Busca os formulários do departamento do administrador atual cujo
  # título do template, nome ou código da matéria correspondam ao
  # padrão de pesquisa.
  #
  # Argumentos:
  # - +padrao+: String já no formato +"%termo%"+, sanitizada.
  #
  # Retorno:
  # - Retorna um +ActiveRecord::Relation+ de Formulario, filtrado e
  #   ordenado pelos mais recentes.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, executada de forma lazy.
  #   Consome +current_administrador.departamento+.
  def pesquisar_formularios(padrao)
    Formulario
      .do_departamento(current_administrador.departamento)
      .joins(:template, turma: :materia)
      .where(
        "LOWER(templates.titulo) LIKE :padrao OR LOWER(materias.nome) LIKE :padrao OR LOWER(materias.codigo) LIKE :padrao",
        padrao: padrao
      )
      .includes(:template, turma: :materia)
      .recentes
  end

  ##
  # Busca as matérias cujo nome ou código correspondam ao padrão de
  # pesquisa, ordenadas por nome.
  #
  # Argumentos:
  # - +padrao+: String já no formato +"%termo%"+, sanitizada.
  #
  # Retorno:
  # - Retorna um +ActiveRecord::Relation+ de Materia, filtrado e
  #   ordenado por nome.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, executada de forma lazy.
  def pesquisar_materias(padrao)
    Materia.where(
      "LOWER(nome) LIKE :padrao OR LOWER(codigo) LIKE :padrao",
      padrao: padrao
    ).order(:nome)
  end

  ##
  # Espera o último "token" do termo como identificador de turma (letra ou
  # número) e o restante como nome/código da matéria. Ex.: "CIC0001 A",
  # "Estruturas de Dados 1".
  #
  # Interpreta o termo de pesquisa como "<matéria> <identificador da
  # turma>" e busca as turmas correspondentes, combinando o número da
  # turma com o nome/código da matéria.
  #
  # Argumentos:
  # - +termo+: String com o termo de pesquisa completo, não
  #   sanitizado.
  #
  # Retorno:
  # - Retorna um +ActiveRecord::Relation+ de Turma correspondente ao
  #   padrão interpretado, ou +Turma.none+ caso o termo não corresponda
  #   ao formato esperado (regex) ou o nome da matéria extraído esteja
  #   em branco.
  #
  # Efeitos colaterais:
  # - *Banco de Dados*: apenas leitura, executada de forma lazy.
  def pesquisar_turmas(termo)
    match = termo.match(/\A(.+?)\s+([A-Za-z]|\d{1,2})\z/)
    return Turma.none unless match

    materia_termo = match[1].strip
    return Turma.none if materia_termo.blank?

    numero = Turma.numero_de_codigo_exibicao(match[2])
    padrao_materia = "%#{ActiveRecord::Base.sanitize_sql_like(materia_termo.downcase)}%"

    Turma
      .joins(:materia)
      .includes(:materia)
      .where(numero: numero)
      .where(
        "LOWER(materias.nome) LIKE :padrao OR LOWER(materias.codigo) LIKE :padrao",
        padrao: padrao_materia
      )
      .order(:numero)
  end

  ##
  # Matéria/turma não têm relação com templates, então qualquer navegação
  # a partir dessas sugestões já remove "templates" da lista de tipos e
  # marca sem_templates=1, para a topbar desabilitar esse checkbox.
  #
  # Monta a URL de pesquisa a ser usada quando o usuário clica na
  # sugestão de uma matéria, ajustando os tipos de resultado para
  # excluir "templates".
  #
  # Argumentos:
  # - +materia+: instância de Materia cujo nome será usado como termo
  #   de pesquisa na URL gerada.
  # - +tipos+: Array de String com os tipos de resultado atualmente
  #   selecionados.
  #
  # Retorno:
  # - Retorna uma String com a URL gerada por +pesquisa_path+, já com
  #   +filtro_ativo+, +tipos+ (sem "templates") e +sem_templates+
  #   definidos.
  #
  # Efeitos colaterais:
  # - Nenhum.
  def materia_suggestion_url(materia, tipos)
    tipos_aplicaveis = tipos - [ "templates" ]
    tipos_aplicaveis = %w[avaliacoes formularios] if tipos_aplicaveis.empty?

    pesquisa_path(q: materia.nome, filtro_ativo: "1", tipos: tipos_aplicaveis, sem_templates: "1")
  end

  ##
  # Monta a URL de pesquisa a ser usada quando o usuário clica na
  # sugestão de uma turma, ajustando os tipos de resultado para excluir
  # "templates" e restringindo o resultado à turma selecionada.
  #
  # Argumentos:
  # - +turma+: instância de Turma cujo nome de exibição será usado
  #   como termo de pesquisa e cujo ID será incluído na URL gerada.
  # - +tipos+: Array de String com os tipos de resultado atualmente
  #   selecionados.
  #
  # Retorno:
  # - Retorna uma String com a URL gerada por +pesquisa_path+, já com
  #   +filtro_ativo+, +tipos+ (sem "templates"), +sem_templates+ e
  #   +turma_id+ definidos.
  #
  # Efeitos colaterais:
  # - Nenhum.
  def turma_suggestion_url(turma, tipos)
    tipos_aplicaveis = tipos - [ "templates" ]
    tipos_aplicaveis = %w[avaliacoes formularios] if tipos_aplicaveis.empty?

    pesquisa_path(
      q: turma.nome_exibicao,
      filtro_ativo: "1",
      tipos: tipos_aplicaveis,
      sem_templates: "1",
      turma_id: turma.id
    )
  end

  ##
  # before_action que garante que apenas usuários autenticados e com
  # perfil de administrador possam acessar as actions de gerenciamento,
  # importação de dados e envio de solicitações.
  #
  # Argumentos:
  # - Nenhum diretamente. Utiliza +current_user+.
  #
  # Retorno:
  # - Não possui retorno relevante (callback de before_action).
  #
  # Efeitos colaterais:
  # - *Sessão*: caso o usuário não esteja autenticado ou não seja
  #   administrador, limpa a sessão (+session.clear+) e zera
  #   +@current_user+.
  # - *Redirecionamento*: nesses mesmos casos, redireciona para a
  #   página inicial com flash de erro, impedindo o processamento da
  #   action solicitada.
  def verificar_admin
    if current_user.nil? || !current_user.administrador?
      session.clear
      @current_user = nil
      redirect_to root_path, flash: { error: "Acesso restrito. Por favor, faça login como administrador." }
    end
  end
end
