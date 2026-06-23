class TemplatesController < ApplicationController
  before_action :require_admin!
  before_action :set_template, only: %i[ show edit update destroy ]
  before_action :authorize_template_access!, only: %i[ show edit update destroy ]

  # GET /templates or /templates.json
  def index
    @templates = current_admin.templates
  end

  # GET /templates/1 or /templates/1.json
  def show
  end

  # GET /templates/new
  def new
    @template = Template.new
    @questoes_attrs = []
  end

  # GET /templates/1/edit
  def edit
    @questoes_attrs = @template.questaos.map do |questao|
      { id: questao.id, enunciado: questao.enunciado, tipo: questao.tipo }
    end
  end

  # POST /templates or /templates.json
  def create
    @template = Template.new(template_params)
    @questoes_attrs = extract_questoes_attrs

    if params[:add_questao]
      @questoes_attrs << blank_questao_attrs
      return render :new, status: :ok
    end

    if @template.valid? && questoes_attrs_valid?
      Template.transaction do
        @template.save!
        @questoes_attrs.each do |questao|
          @template.questaos.create!(enunciado: questao[:enunciado], tipo: questao[:tipo])
        end
      end
      redirect_to templates_path, notice: "Template criado com sucesso."
    else
      render :new, status: :unprocessable_content
    end
  end

  # PATCH/PUT /templates/1 or /templates/1.json
  def update
    @template.assign_attributes(template_params)
    @questoes_attrs = extract_questoes_attrs

    if params[:add_questao]
      @questoes_attrs << blank_questao_attrs
      return render :edit, status: :ok
    end

    novas_questoes = @questoes_attrs.reject { |questao| questao[:id].present? }

    if @template.valid? && novas_questoes_validas?(novas_questoes)
      Template.transaction do
        @template.save!
        @questoes_attrs.each do |questao|
          if questao[:id].present?
            @template.questaos.find(questao[:id]).update!(enunciado: questao[:enunciado], tipo: questao[:tipo])
          else
            @template.questaos.create!(enunciado: questao[:enunciado], tipo: questao[:tipo])
          end
        end
      end
      redirect_to templates_path, notice: "Template atualizado com sucesso."
    else
      render :edit, status: :unprocessable_content
    end
  end

  # DELETE /templates/1 or /templates/1.json
  def destroy
    @template.destroy!
    redirect_to templates_path, notice: "Template deletado com sucesso.", status: :see_other
  end

  private
    def set_template
      @template = Template.find(params.expect(:id))
    end

    def authorize_template_access!
      redirect_to templates_path, alert: "Você não tem acesso a esse template" unless @template.admin_id == current_admin.id
    end

    def template_params
      attrs = params.expect(template: [ :title, :target_role ])
      attrs[:admin_id] = current_admin.id
      attrs
    end

    def extract_questoes_attrs
      raw = params.dig(:template, :questaos)
      return [] unless raw

      raw.values.map do |questao|
        attrs = { enunciado: questao[:enunciado].to_s, tipo: questao[:tipo].presence || "rating" }
        attrs[:id] = questao[:id] if questao[:id].present?
        attrs
      end
    end

    def blank_questao_attrs
      { enunciado: "", tipo: "rating" }
    end

    def questoes_attrs_valid?
      if @questoes_attrs.any? { |questao| questao[:enunciado].blank? }
        @template.errors.add(:base, "Questão não possui enunciado")
        false
      else
        true
      end
    end

    def novas_questoes_validas?(novas_questoes)
      if novas_questoes.any? { |questao| questao[:enunciado].blank? }
        @template.errors.add(:base, "A nova questão não possui enunciado")
        false
      else
        true
      end
    end
end
