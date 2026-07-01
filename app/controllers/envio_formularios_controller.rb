class EnvioFormulariosController < ApplicationController
  before_action :exigir_discente!
  before_action :set_formulario

  def new
    if discente_atual&.ja_respondeu?(@formulario)
      redirect_to minha_resposta_formulario_path(@formulario),
        notice: "Este formulário já foi respondido"
      return
    end

    @questoes = @formulario.questoes.includes(questao_template: :opcao_questoes)
  end

  def create
    return redirect_to formularios_path, alert: "Este formulário já foi respondido" if discente_atual&.ja_respondeu?(@formulario)

    respostas_params = params[:respostas] || {}
    questoes = @formulario.questoes
    erro = mensagem_erro_validacao(questoes, respostas_params)

    return render_erro_validacao(questoes, erro) if erro

    salvar_envio(questoes, respostas_params)
  rescue ActiveRecord::RecordInvalid => e
    render_erro_salvamento(e.message)
  end

  private

  def set_formulario
    @formulario = Formulario.find(params[:formulario_id] || params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to formularios_path, alert: "Formulário não encontrado."
  end

  def mensagem_erro_validacao(questoes, respostas_params)
    return "Todos os campos obrigatórios devem ser preenchidos" if campos_vazios?(questoes, respostas_params)
    "Por favor, insira um valor válido entre 1 e 5" if valores_invalidos?(questoes, respostas_params)
  end

  def campos_vazios?(questoes, respostas_params)
    questoes.any? { |q| respostas_params[q.id.to_s].blank? }
  end

  def valores_invalidos?(questoes, respostas_params)
    questoes.any? do |q|
      valor = respostas_params[q.id.to_s].to_s.strip
      numerico = Integer(valor, exception: false)
      numerico && (numerico < 1 || numerico > 5)
    end
  end

  def render_erro_validacao(questoes, mensagem)
    @questoes = questoes.includes(questao_template: :opcao_questoes)
    flash.now[:alert] = mensagem
    render :new, status: :unprocessable_entity
  end

  def render_erro_salvamento(mensagem)
    @questoes = @formulario.questoes.includes(questao_template: :opcao_questoes)
    flash.now[:alert] = mensagem
    render :new, status: :unprocessable_entity
  end

  def salvar_envio(questoes, respostas_params)
    envio = EnvioFormulario.new(formulario: @formulario, discente: discente_atual)

    EnvioFormulario.transaction do
      envio.save!
      questoes.each do |questao|
        conteudo = respostas_params[questao.id.to_s].to_s.strip
        Resposta.create!(envio_formulario: envio, questao: questao, conteudo: conteudo)
      end
    end

    redirect_to formularios_path, notice: "Avaliação enviada com sucesso"
  end
end
