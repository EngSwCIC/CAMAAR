# Exibe formulários de avaliação e processa o envio de respostas pelo discente.
class FormulariosController < ApplicationController
  before_action :require_login

  # Exibe um formulário com suas questões.
  #
  # Parâmetros: +:id+ via params — ID do formulário.
  # Retorno: renderiza a view +show+ com +@formulario+ e +@questoes+.
  def show
    @formulario = Formulario.includes(:questoes).find(params[:id])
    @questoes = @formulario.questoes
  end

  # Processa o envio das respostas de um formulário pelo discente.
  #
  # Parâmetros: +:id+ via params (ID do formulário); +:respostas+ via params
  # — hash com questao_id => conteudo.
  # Efeito colateral: salva as respostas no banco dentro de uma transação e
  # redireciona para +root_path+ com confirmação. Em caso de respostas
  # inválidas, redireciona de volta ao formulário com alerta. Em caso de
  # erro inesperado, redireciona ao formulário com mensagem de erro.
  def responder
    @formulario = Formulario.find(params[:id])
    respostas_params = params[:respostas] || {}

    if respostas_invalidas?(respostas_params)
      redirect_to formulario_path(@formulario), alert: "Erro: Todos os campos obrigatórios precisam ser preenchidos."
      return
    end

    salvar_respostas(respostas_params)
    redirect_to root_path, notice: "Avaliação enviada com sucesso! Obrigado pela sua participação."
  rescue StandardError => e
    redirect_to formulario_path(@formulario), alert: "Erro ao enviar avaliação. Tente novamente."
  end

  private

  # Verifica se o conjunto de respostas é inválido (vazio ou com campos
  # em branco).
  #
  # Parâmetros: +respostas_params+ — hash com questao_id => conteudo.
  # Retorno: +true+ se inválido, +false+ se todas as respostas estão
  # preenchidas.
  def respostas_invalidas?(respostas_params)
    respostas_params.blank? || respostas_params.values.any?(&:blank?)
  end

  # Persiste todas as respostas do formulário em uma única transação.
  #
  # Parâmetros: +respostas_params+ — hash com questao_id => conteudo.
  # Efeito colateral: cria registros de +Resposta+ no banco. Lança exceção
  # se qualquer criação falhar, revertendo toda a transação.
  def salvar_respostas(respostas_params)
    ActiveRecord::Base.transaction do
      respostas_params.each do |questao_id, conteudo|
        Resposta.create!(
          questao_id: questao_id,
          discente_id: current_pessoa.discente.id,
          conteudo: conteudo
        )
      end
    end
  end
end
