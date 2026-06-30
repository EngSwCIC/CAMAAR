class TemplatesController < ApplicationController
  before_action :require_admin

  # Lista todos os templates de avaliação cadastrados e inicia uma nova instância vazia.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Renderiza a view de listagem/criação de templates.
  #
  # <b>Efeitos Colaterais:</b>
  # * Define as variáveis de instância +@templates+ e +@template+.
  def index
    @templates = Template.all
    @template = Template.new
  end

  # Cria um novo template e suas respectivas perguntas associadas em uma transação atômica.
  #
  # <b>Parâmetros:</b>
  # * +params[:template]+ - Hash contendo o título, descrição, perfil alvo e perguntas enviadas.
  #
  # <b>Retorno:</b>
  # * Redirecionamento para a lista de templates ou re-renderização com status de erro.
  #
  # <b>Efeitos Colaterais:</b>
  # * Cria um registro na tabela +templates+ e múltiplos registros na tabela +questao_templates+ caso válido. Define mensagens no +flash+.
  def create
    @template = build_template

    return if handle_missing_title

    valid_questions = extract_valid_questions
    return if handle_missing_questions(valid_questions)

    @template.skip_questions_validation = true
    save_template_and_questions(valid_questions)
  rescue => e
    handle_save_error("Erro ao criar template: #{e.message}")
  end

  # Renderiza a página para edição de dados básicos de um template existente (título e descrição).
  #
  # <b>Parâmetros:</b>
  # * +params[:id]+ - O ID do template desejado (Integer/String).
  #
  # <b>Retorno:</b>
  # * Renderiza a view de edição.
  #
  # <b>Efeitos Colaterais:</b>
  # * Define a variável de instância +@template+.
  def edit
    @template = Template.find(params[:id])
  end

  # Processa a atualização de dados básicos de um template.
  #
  # <b>Parâmetros:</b>
  # * +params[:id]+ - O ID do template desejado (Integer/String).
  # * +params[:template]+ - Hash contendo os dados modificados do template (título, descrição).
  #
  # <b>Retorno:</b>
  # * Redirecionamento para a listagem ou re-renderização em caso de falha de validação.
  #
  # <b>Efeitos Colaterais:</b>
  # * Atualiza e salva o registro do template no banco de dados. Define mensagens de sucesso/erro no +flash+.
  def update
    @template = Template.find(params[:id])
    if @template.update(template_params)
      flash[:notice] = "Template atualizado com sucesso!"
      redirect_to templates_path
    else
      flash.now[:alert] = "Não foi possível atualizar o template."
      render :edit, status: :unprocessable_entity
    end
  end

  # Exclui um template caso este não tenha nenhum formulário de avaliação ativo/vinculado.
  #
  # <b>Parâmetros:</b>
  # * +params[:id]+ - O ID do template desejado (Integer/String).
  #
  # <b>Retorno:</b>
  # * Redirecionamento para a listagem de templates.
  #
  # <b>Efeitos Colaterais:</b>
  # * Exclui o registro do template (e suas perguntas em cascata) do banco de dados se permitido. Define alertas/avisos no +flash+.
  def destroy
    @template = Template.find(params[:id])
    if @template.formularios.exists?
      flash[:alert] = "Não é possível deletar este template pois ele já possui formulários de avaliações vinculados."
    else
      @template.destroy
      flash[:notice] = "Template excluído com sucesso!"
    end
    redirect_to templates_path
  end

  private

  # Salva o template e cria suas respectivas perguntas em uma transação atômica do banco de dados.
  #
  # <b>Parâmetros:</b>
  # * +valid_questions+ - Array contendo os hashes das perguntas validadas.
  #
  # <b>Retorno:</b>
  # * Redirecionamento para a listagem de templates ou chamada para tratamento de erro de salvamento.
  #
  # <b>Efeitos Colaterais:</b>
  # * Commita a transação no banco de dados e define mensagem de sucesso no +flash+.
  def save_template_and_questions(valid_questions)
    ActiveRecord::Base.transaction do
      if @template.save
        create_questions(valid_questions)
        flash[:notice] = "Template criado com sucesso!"
        redirect_to templates_path
      else
        handle_save_error("Não foi possível salvar o template.")
      end
    end
  end

  # Permite apenas os parâmetros seguros de modificação do template.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Instância de +ActionController::Parameters+ contendo os campos permitidos.
  def template_params
    params.require(:template).permit(:titulo, :descricao)
  end

  # Constrói uma nova instância de template a partir dos parâmetros de requisição.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Instância não persistida de +Template+.
  def build_template
    p = params[:template]
    Template.new(
      titulo: p[:titulo],
      perfil_alvo: p[:perfil_alvo],
      criador: current_user,
      descricao: p[:descricao] || "Template para avaliações de #{p[:perfil_alvo]}"
    )
  end

  # Intercepta e trata se o template submetido está sem título.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Boolean (+true+ se faltar título com re-renderização ativa, +false+ caso contrário).
  #
  # <b>Efeitos Colaterais:</b>
  # * Carrega a lista completa de +@templates+, insere alerta no +flash.now+ e renderiza a view +:index+.
  def handle_missing_title
    if params[:template][:titulo].blank?
      @templates = Template.all
      flash.now[:alert] = "Nome do Template não pode ficar em branco"
      render :index, status: :unprocessable_entity
      true
    else
      false
    end
  end

  # Filtra a lista de perguntas enviadas removendo as que possuem o enunciado/texto em branco.
  #
  # <b>Parâmetros:</b>
  # * Nenhum.
  #
  # <b>Retorno:</b>
  # * Array filtrado contendo apenas perguntas com texto preenchido.
  def extract_valid_questions
    return [] unless params[:template][:perguntas].present?
    params[:template][:perguntas].reject { |p_param| p_param[:texto].blank? }
  end

  # Intercepta e trata se nenhuma pergunta válida foi inserida no template.
  #
  # <b>Parâmetros:</b>
  # * +valid_questions+ - Coleção de perguntas analisadas (Array).
  #
  # <b>Retorno:</b>
  # * Boolean (+true+ se não houver perguntas válidas e re-renderização for efetuada, +false+ caso contrário).
  #
  # <b>Efeitos Colaterais:</b>
  # * Recarrega +@templates+, define alerta no +flash.now+ e renderiza a view +:index+.
  def handle_missing_questions(valid_questions)
    if valid_questions.empty?
      @templates = Template.all
      flash.now[:alert] = "O template deve ter ao menos uma pergunta"
      render :index, status: :unprocessable_entity
      true
    else
      false
    end
  end

  # Cria e vincula as perguntas válidas ao template recém-criado.
  #
  # <b>Parâmetros:</b>
  # * +valid_questions+ - Coleção de parâmetros das perguntas (Array de Hashes).
  #
  # <b>Retorno:</b>
  # * +nil+
  #
  # <b>Efeitos Colaterais:</b>
  # * Grava múltiplos registros no banco de dados na tabela +questao_templates+.
  def create_questions(valid_questions)
    valid_questions.each_with_index do |p_param, index|
      QuestaoTemplate.create!(
        template: @template,
        enunciado: p_param[:texto],
        tipo: p_param[:tipo],
        obrigatoria: true,
        ordem: index + 1
      )
    end
  end

  # Trata e notifica falhas ocorridas na transação ou no salvamento do template.
  #
  # <b>Parâmetros:</b>
  # * +message+ - Mensagem descritiva do erro (String).
  #
  # <b>Retorno:</b>
  # * Renderiza a view +:index+ com status +:unprocessable_entity+.
  #
  # <b>Efeitos Colaterais:</b>
  # * Recarrega +@templates+ e define alerta no +flash.now+.
  def handle_save_error(message)
    @templates = Template.all
    flash.now[:alert] = message
    render :index, status: :unprocessable_entity
  end
end
