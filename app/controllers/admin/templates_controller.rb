class Admin::TemplatesController < ApplicationController
  layout 'templates_fill', only: [:new, :edit,:index]
  def index
    @valid_templates = Template
                         .joins(ligacao_pergunta: :perguntas)
                         .distinct
                         .includes(ligacao_pergunta: :perguntas)

    @invalid_templates = Template.all - @valid_templates

    # puts "Templates válidos: #{@valid_templates.count}"
    # puts "Templates no banco: #{Template.count}"


    @show_incompatibility_message = Template.count != @valid_templates.count
  end

  def new
    @template = Template.new
  end

  def create
    if params[:questions].blank? || params[:questions].reject { |q| q[:text].blank? }.empty?
      flash.now[:error] = "O template precisa ter pelo menos uma pergunta."
      return render :new
    end

    ActiveRecord::Base.transaction do

      ligacao = LigacaoPergunta.create!

      @template = Template.create!(
        nome: params[:template][:nome],
        ligacao_pergunta: ligacao
      )

      puts "PARAM QUESTIONS: #{params[:questions].inspect}"
      Array(params[:questions]).each do |q|
        pergunta = Pergunta.create!(
          ligacao_pergunta: ligacao,
          tipo:             q[:type].to_i,
          pergunta:         q[:text]
        )

        # Só se for de múltipla escolha
        if q[:type].to_i.zero? && q[:options].present?
          q[:options].reject(&:blank?).each_with_index do |opt, idx|
            Opcao.create!(
              pergunta: pergunta,
              item:     idx + 1,
              opcao:    opt
            )
          end
        end
      end

      redirect_to admin_templates_path,
                  notice: "Template Criado Com Sucesso"
    end

  rescue ActiveRecord::RecordInvalid => e
    flash.now[:error] = e.record.errors.full_messages.join(", ")
    return render :new
  end

  def edit
    @template  = Template.find(params[:id])
    @ligacao   = @template.ligacao_pergunta
    @questions = @template.ligacao_pergunta.perguntas.includes(:opcoes)
  end

  def update
    @template = Template.find(params[:id])

    if params[:questions].blank? || params[:questions].reject { |q| q[:text].blank? }.empty?
      flash.now[:error] = "O template precisa ter pelo menos uma pergunta."
      return render :edit
    end

    ActiveRecord::Base.transaction do
      ligacao = @template.ligacao_pergunta
      ligacao.perguntas.destroy_all

      @template.update!(nome: params[:template][:nome])

      Array(params[:questions]).each do |q|
        pergunta = Pergunta.create!(
          ligacao_pergunta: ligacao,
          tipo:             q[:type].to_i,
          pergunta:         q[:text]
        )
        if q[:type].to_i.zero? && q[:options].present?
          q[:options].each_with_index do |opt, idx|
            Opcao.create!(pergunta: pergunta, item: idx + 1, opcao: opt)
          end
        end
      end

      redirect_to admin_templates_path, notice: "Template atualizado com sucesso"
    end
  rescue ActiveRecord::RecordInvalid => e
    flash.now[:error] = e.record.errors.full_messages.join(", ")
    render :edit
  end

  def destroy
    @template = Template.find(params[:id])
    @template.destroy!
    redirect_to admin_templates_path, notice: "Template excluído com sucesso"
  end

  private

  def template_params
    params.require(:template).permit(:nome)
  end
end