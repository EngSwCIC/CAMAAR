# Gerencia o CRUD de templates de formulário de avaliação.
#
# Templates são modelos reutilizáveis criados por administradores que definem a
# estrutura de uma avaliação (questões e opções de resposta). Cada administrador
# só pode gerenciar seus próprios templates. Utiliza o layout "gerenciamento" e
# suporta criação e edição de elementos e campos via nested attributes.
class TemplatesController < ApplicationController
  layout "gerenciamento"
  before_action :require_login

  include AdminAutenticavel

  before_action :set_admin
  before_action :set_template, only: %i[ show edit update destroy ]

  # Lista todos os templates do administrador com seus elementos e campos.
  #
  # @return [void]
  def index
    @templates = @admin.templates.includes(elementos: :campos)
  end

  # Redireciona para a lista de templates do administrador.
  #
  # @return [void]
  # @note Redireciona para +admin_templates_path+.
  def show
    redirect_to admin_templates_path(@admin)
  end

  # Exibe o formulário de criação de novo template com um elemento e um campo iniciais.
  #
  # @return [void]
  def new
    @templates = @admin.templates
    @template = @admin.templates.build
    elemento = @template.elementos.build
    elemento.campos.build
  end

  # Exibe o formulário de edição de um template existente.
  #
  # @return [void]
  # @note Se o template não possuir elementos, cria um elemento vazio com um campo
  #   para facilitar o preenchimento do formulário.
  def edit
    @templates = @admin.templates
    if @template.elementos.empty?
      elemento = @template.elementos.build
      elemento.campos.build
    end
  end

  # Cria um novo template com os parâmetros permitidos.
  #
  # @return [void]
  # @note Persiste o template e seus elementos/campos no banco de dados via nested
  #   attributes. Em caso de sucesso, redireciona para a lista de templates; em caso
  #   de falha, re-renderiza o formulário de criação.
  def create
    @template = @admin.templates.build(template_params)

    respond_to do |format|
      if @template.save
        format.html { redirect_to admin_templates_path(@admin), notice: "Template criado com sucesso!" }
        format.json { render :show, status: :created, location: @template }
      else
        @templates = @admin.templates
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @template.errors, status: :unprocessable_content }
      end
    end
  end

  # Atualiza os dados de um template existente.
  #
  # @return [void]
  # @note Persiste as alterações no banco de dados, incluindo adição, edição e remoção
  #   de elementos e campos. Em caso de sucesso, redireciona para a lista de templates;
  #   em caso de falha, re-renderiza o formulário de edição.
  def update
    respond_to do |format|
      if @template.update(template_params)
        format.html { redirect_to admin_templates_path(@admin), notice: "Template atualizado com sucesso!" }
        format.json { render :show, status: :ok, location: @template }
      else
        @templates = @admin.templates
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @template.errors, status: :unprocessable_content }
      end
    end
  end

  # Remove permanentemente um template e seus elementos/campos do banco de dados.
  #
  # @return [void]
  # @note Redireciona para a lista de templates após a exclusão.
  def destroy
    @template.destroy!
    respond_to do |format|
      format.html { redirect_to admin_templates_path(@admin), notice: "Template deletado com sucesso!", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Busca o template pelo +:id+ da rota dentro dos templates do administrador.
  #
  # @return [void]
  def set_template
    @template = @admin.templates.find(params.expect(:id))
  end

  # Filtra os parâmetros permitidos para criação/atualização de template.
  #
  # @return [ActionController::Parameters] parâmetros filtrados do template com nested
  #   attributes de elementos e campos
  def template_params
    params.require(:template).permit(
      :nome,
      elementos_attributes: [
        :id, :enunciado, :ordem, :_destroy,
        campos_attributes: [ :id, :tipo_elemento, :enunciado, :ordem, :_destroy ]
      ]
    )
  end
end
