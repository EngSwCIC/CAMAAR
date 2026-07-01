# Gerencia o CRUD de templates de formulário na área administrativa.
class Admin::TemplatesController < Admin::BaseController
  # Lista todos os templates cadastrados.
  #
  # Efeito colateral: atribui +@templates+ com todos os registros de
  # +Template+.
  def index
    @templates = Template.all
  end

  # Exibe o formulário para criação de um novo template.
  #
  # Efeito colateral: inicializa +@template+ com uma questão em branco
  # aninhada, pronta para preenchimento.
  def new
    @template = Template.new
    @template.template_questoes.build
  end

  # Processa a criação de um novo template.
  #
  # Parâmetros: +:template+ com +:nome+ e +:template_questoes_attributes+
  # via params.
  # Efeito colateral: salva o template no banco associado à pessoa atual.
  # Redireciona para +admin_templates_path+ com confirmação em caso de
  # sucesso, ou renderiza +:new+ com alerta em caso de falha.
  def create
    @template = current_pessoa.templates.build(template_params)
    if @template.save
      redirect_to admin_templates_path, notice: 'Template criado com sucesso.'
    else
      @template.template_questoes.build if @template.template_questoes.empty?
      flash.now[:alert] = 'O nome do template é obrigatório.'
      render :new, status: :unprocessable_entity
    end
  end

  # Exibe o formulário de edição de um template existente.
  #
  # Parâmetros: +:id+ via params — ID do template.
  # Efeito colateral: garante ao menos uma questão aninhada inicializada
  # caso o template não possua questões.
  def edit
    @template = Template.find(params[:id])
    @template.template_questoes.build if @template.template_questoes.empty?
  end

  # Processa a atualização de um template existente.
  #
  # Parâmetros: +:id+ via params; +:template+ com +:nome+ e
  # +:template_questoes_attributes+ via params.
  # Efeito colateral: atualiza o template no banco. Redireciona para
  # +admin_templates_path+ em caso de sucesso, ou renderiza +:edit+ com
  # alerta em caso de falha.
  def update
    @template = Template.find(params[:id])
    if @template.update(template_params)
      redirect_to admin_templates_path, notice: 'Template atualizado com sucesso.'
    else
      @template.template_questoes.build if @template.template_questoes.empty?
      flash.now[:alert] = 'O nome do template é obrigatório. Erro apontando os campos que precisam ser corrigidos.'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Filtra os parâmetros permitidos para criação/atualização de template.
  #
  # Retorno: ActionController::Parameters com +:nome+ e atributos aninhados
  # de +:template_questoes+.
  def template_params
    params.require(:template).permit(:nome, template_questoes_attributes: [:id, :enunciado, :tipo_resposta, :opcoes, :_destroy])
  end
end
