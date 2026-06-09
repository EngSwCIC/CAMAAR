# app/controllers/envio_formularios_controller.rb
class EnvioFormulariosController < ApplicationController
  before_action :exigir_discente!
  before_action :set_formulario
  before_action :verificar_acesso_a_turma!
  before_action :verificar_prazo!
  before_action :verificar_nao_respondido!, only: [:new]

  # GET /envio_formularios/new?formulario_id=X
  def new
    @questoes = @formulario.questoes
                            .includes(questao_template: :opcao_questoes)
                            .order(:id)
  end

  # POST /envio_formularios
  def create
    ActiveRecord::Base.transaction do
      @envio = EnvioFormulario.new(
        formulario: @formulario,
        discente:   discente_atual,
        enviado_em: Time.current
      )

      unless @envio.save
        # trata tentativa de resposta duplicada (constraint UNIQUE)
        if @envio.errors[:formulario_id].any?
          redirect_to minha_resposta_formulario_path(@formulario),
            notice: "Você já respondeu este formulário."
          return
        end
        raise ActiveRecord::Rollback
      end

      questoes_ids = @formulario.questoes.pluck(:id)
      respostas_params = params[:respostas] || {}

      # valida que todas as questões foram respondidas
      questoes_nao_respondidas = questoes_ids.reject do |id|
        respostas_params[id.to_s].present?
      end

      if questoes_nao_respondidas.any?
        @envio.destroy
        @questoes = @formulario.questoes.includes(questao_template: :opcao_questoes).order(:id)
        flash.now[:alert] = "Todas as questões são obrigatórias"
        render :new, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end

      questoes_ids.each do |questao_id|
        Resposta.create!(
          envio_formulario: @envio,
          questao_id:       questao_id,
          conteudo:         respostas_params[questao_id.to_s]
        )
      end
    end

    redirect_to root_path, notice: "Formulário respondido com sucesso!"
  end

  private

  def set_formulario
    @formulario = Formulario.find_by(id: params[:formulario_id])
    unless @formulario
      redirect_to formularios_path, alert: "Formulário não encontrado." and return
    end
  end

  def verificar_acesso_a_turma!
    unless discente_atual.turmas.include?(@formulario.turma)
      redirect_to formularios_path, alert: "Você não tem acesso a este formulário." and return
    end
  end

  def verificar_prazo!
    if @formulario.fechado?
      redirect_to formularios_path,
        alert: "O prazo para responder este formulário já encerrou." and return
    end
  end

  def verificar_nao_respondido!
    if discente_atual.ja_respondeu?(@formulario)
      redirect_to minha_resposta_formulario_path(@formulario),
        notice: "Você já respondeu este formulário." and return
    end
  end
end
