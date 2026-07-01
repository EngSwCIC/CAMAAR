# frozen_string_literal: true

# Controla as telas e operações HTTP para gerenciamento de templates.
#
# Os métodos públicos correspondem às actions Rails e coordenam autorização,
# preparação de dados para views e persistência dos templates.
class TemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_template, only: %i[show edit update destroy]

  ##
  # Lista os templates visíveis para o administrador autenticado.
  #
  # Argumentos:
  # - Não recebe argumentos explicitamente. Usa o usuário autenticado e a
  #   policy de templates da requisição atual.
  #
  # Retorno:
  # - Não usa valor de retorno próprio. A action deixa +@user_templates+ e
  #   +@other_templates+ disponíveis para a view.
  #
  # Efeitos colaterais:
  # - Consulta o banco de dados.
  # - Pode interromper a requisição se a autorização falhar.
  def index
    authorize! Template

    templates = policy_scope(Template)
      .includes(adm: :usuario)
      .recentes

    @user_templates = templates.criados_por(current_administrador)
    @other_templates = templates.criados_por_outros(current_administrador)
  end

  ##
  # Exibe um template específico.
  #
  # Argumentos:
  # - Não recebe argumentos explicitamente. Usa +params[:id]+ indiretamente
  #   pelo callback +set_template+.
  #
  # Retorno:
  # - Não usa valor de retorno próprio. A action expõe +@template+ para a view.
  #
  # Efeitos colaterais:
  # - Consulta o banco no callback +set_template+.
  # - Pode interromper a requisição se a autorização falhar.
  def show
    authorize! @template
  end

  ##
  # Prepara o formulário de criação de template.
  #
  # Argumentos:
  # - Não recebe argumentos explicitamente. Usa o administrador autenticado.
  #
  # Retorno:
  # - Não usa valor de retorno próprio. A action inicializa +@template+ para
  #   renderização do formulário.
  #
  # Efeitos colaterais:
  # - Instancia objetos em memória para os campos aninhados.
  # - Pode interromper a requisição se a autorização falhar.
  def new
    @template = Template.new(adm: current_administrador)
    preparar_campos_do_template

    authorize! @template
  end

  ##
  # Cria um template com os parâmetros enviados pelo formulário.
  #
  # Argumentos:
  # - Não recebe argumentos explicitamente. Usa +params[:template]+ e o
  #   administrador autenticado.
  #
  # Retorno:
  # - Não usa valor de retorno próprio. Em caso de sucesso, redireciona para o
  #   template criado; em caso de erro, renderiza novamente a tela de criação.
  #
  # Efeitos colaterais:
  # - Insere registros no banco quando o template é válido.
  # - Redireciona para a página do template criado ou renderiza +new+ com
  #   status +unprocessable_entity+.
  # - Pode interromper a requisição se a autorização falhar.
  def create
    @template = build_template

    authorize! @template

    if @template.save
      redirect_to @template, notice: "Template criado com sucesso."
    else
      preparar_campos_do_template

      render :new, status: :unprocessable_entity
    end
  end

  ##
  # Prepara o formulário de edição de um template existente.
  #
  # Argumentos:
  # - Não recebe argumentos explicitamente. Usa +params[:id]+ indiretamente
  #   pelo callback +set_template+.
  #
  # Retorno:
  # - Não usa valor de retorno próprio. A action prepara +@template+ para a
  #   view de edição.
  #
  # Efeitos colaterais:
  # - Consulta o banco no callback +set_template+.
  # - Instancia objetos em memória para campos aninhados faltantes.
  # - Pode interromper a requisição se a autorização falhar.
  def edit
    preparar_campos_do_template

    authorize! @template
  end

  ##
  # Atualiza um template existente e sua estrutura de questões/opções.
  #
  # Argumentos:
  # - Não recebe argumentos explicitamente. Usa +params[:id]+ e
  #   +params[:template]+ da requisição.
  #
  # Retorno:
  # - Não usa valor de retorno próprio. Redireciona quando a atualização é
  #   válida; renderiza +edit+ quando há erro de validação.
  #
  # Efeitos colaterais:
  # - Atualiza registros no banco em transação.
  # - Reordena temporariamente registros persistidos para evitar conflito de
  #   índices únicos antes do update final.
  # - Redireciona para a página do template ou renderiza +edit+ com status
  #   +unprocessable_entity+.
  # - Pode interromper a requisição se a autorização falhar.
  def update
    authorize! @template

    template_atualizado = atualizar_template_com_reordenacao

    if template_atualizado
      redirect_to @template, notice: "Template atualizado com sucesso."
    else
      preparar_campos_do_template

      render :edit, status: :unprocessable_entity
    end
  end

  ##
  # Remove um template existente.
  #
  # Argumentos:
  # - Não recebe argumentos explicitamente. Usa +params[:id]+ indiretamente
  #   pelo callback +set_template+.
  #
  # Retorno:
  # - Não usa valor de retorno próprio. Redireciona para a listagem de
  #   templates após a remoção.
  #
  # Efeitos colaterais:
  # - Remove o template do banco de dados.
  # - Redireciona para +templates_path+ com mensagem de sucesso.
  # - Pode interromper a requisição se a autorização falhar.
  def destroy
    authorize! @template

    @template.destroy

    redirect_to templates_path, notice: "Template excluído com sucesso."
  end

  private

  ##
  # Carrega o template informado na rota.
  #
  # Argumentos:
  # - Não recebe argumentos explicitamente. Usa +params[:id]+.
  #
  # Retorno:
  # - Retorna o objeto atribuído a +@template+ por convenção de atribuição Ruby.
  # - Levanta exceção se o registro não existir.
  #
  # Efeitos colaterais:
  # - Consulta o banco de dados.
  # - Define a variável de instância +@template+.
  def set_template
    @template = Template.find(params[:id])
  end

  ##
  # Monta um novo template a partir dos parâmetros permitidos.
  #
  # Argumentos:
  # - Não recebe argumentos explicitamente. Usa +template_params+ e
  #   +current_administrador+.
  #
  # Retorno:
  # - Retorna uma instância de +Template+ ainda não persistida.
  #
  # Efeitos colaterais:
  # - Não altera o banco de dados.
  # - Associa o administrador autenticado ao objeto em memória.
  def build_template
    Template.new(template_params).tap do |template|
      template.adm = current_administrador
    end
  end

  ##
  # Garante que o template possua campos aninhados mínimos para o formulário.
  #
  # Argumentos:
  # - Não recebe argumentos explicitamente. Usa +@template+.
  #
  # Retorno:
  # - Retorna a coleção iterada pelo último +each+ quando há utilizações.
  # - Pode retornar uma coleção vazia ou modificada em memória.
  #
  # Efeitos colaterais:
  # - Cria objetos associados em memória quando faltam utilizações ou questões.
  # - Não persiste alterações no banco de dados.
  def preparar_campos_do_template
    utilizacoes = @template.utilizacoes_questoes
    utilizacoes.build(numero: 1) if utilizacoes.empty?

    utilizacoes.each do |utilizacao|
      utilizacao.build_questao(tipo: nil) if utilizacao.questao.blank?
    end
  end

  ##
  # Executa a atualização do template dentro de uma transação.
  #
  # Argumentos:
  # - Não recebe argumentos explicitamente. Usa +@template+ e os parâmetros da
  #   requisição.
  #
  # Retorno:
  # - Retorna +true+ quando a transação conclui com sucesso.
  # - Retorna +nil+ quando ocorre rollback por falha de validação.
  #
  # Efeitos colaterais:
  # - Pode atualizar o banco de dados.
  # - Pode reverter toda a transação quando o update falha.
  def atualizar_template_com_reordenacao
    Template.transaction do
      preparar_reordenacao_de_registros_persistidos
      update_template_or_rollback
    end
  end

  ##
  # Prepara registros já persistidos para receber novos números de ordenação.
  #
  # Argumentos:
  # - Não recebe argumentos explicitamente. Usa +@template+ e
  #   +params[:template][:utilizacoes_questoes_attributes]+.
  #
  # Retorno:
  # - Retorna o resultado de +Templates::PersistedReordering.prepare+.
  #
  # Efeitos colaterais:
  # - Atualiza temporariamente números de utilizações e opções persistidas no
  #   banco de dados.
  def preparar_reordenacao_de_registros_persistidos
    Templates::PersistedReordering.prepare(
      template: @template,
      attributes: params.dig(:template, :utilizacoes_questoes_attributes)
    )
  end

  ##
  # Atualiza o template ou interrompe a transação atual.
  #
  # Argumentos:
  # - Não recebe argumentos explicitamente. Usa +@template+ e
  #   +template_params+.
  #
  # Retorno:
  # - Retorna +true+ quando o update é bem-sucedido.
  # - Levanta +ActiveRecord::Rollback+ quando o update retorna +false+.
  #
  # Efeitos colaterais:
  # - Persiste alterações no banco quando o template é válido.
  # - Dispara rollback da transação quando há erro de validação.
  def update_template_or_rollback
    @template.update(template_params) || raise(ActiveRecord::Rollback)
  end

  ##
  # Filtra os parâmetros permitidos para criação e atualização de templates.
  #
  # Argumentos:
  # - Não recebe argumentos explicitamente. Usa +params[:template]+.
  #
  # Retorno:
  # - Retorna um objeto +ActionController::Parameters+ permitido, contendo os
  #   atributos aceitos para template, utilizações, questões e opções.
  #
  # Efeitos colaterais:
  # - Não altera o banco de dados.
  # - Levanta exceção se a chave obrigatória +:template+ não existir.
  def template_params
    params
      .require(:template)
      .permit(
        :titulo,
        :descricao,
        utilizacoes_questoes_attributes: [
          :id,
          :questao_id,
          :numero,
          :parent_id,
          :_destroy,
          questao_attributes: [
            :id,
            :enunciado,
            :tipo,
            opcoes_attributes: [
              :id,
              :texto,
              :numero,
              :_destroy
            ]
          ]
        ]
      )
  end
end
