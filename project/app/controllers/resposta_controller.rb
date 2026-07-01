##
# Recebe e persiste as respostas de um participante a um formulário de avaliação.
class RespostaController < ApplicationController
  before_action :require_login

  ##
  # Registra uma submissão completa para o formulário informado.
  #
  # Não recebe argumentos explícitos; utiliza +params[:respostum]+.
  #
  # Retorna uma resposta de redirecionamento ao formulário quando há campos em branco
  # ou à listagem após uma submissão válida.
  #
  # Efeitos colaterais: cria ou atualiza submissão e respostas em transação e define
  # mensagens de sucesso ou validação.
  def create
    carregar_formulario_e_respostas
    return redirect_para_formulario_com_alerta if questao_em_branco?

    submissao = Submissao.find_or_create_by!(user: current_user, formulario: @formulario)
    salvar_respostas(submissao)
    redirect_to formularios_path, notice: "Avaliação submetida com sucesso"
  end

  private
    def carregar_formulario_e_respostas
      @formulario = Formulario.find(params[:respostum][:formulario_id])
      @respostas_params = params[:respostum][:respostas] || {}
    end

    def redirect_para_formulario_com_alerta
      redirect_to formulario_path(@formulario), alert: "Por favor, preencha todas as questões obrigatórias"
    end

    def salvar_respostas(submissao)
      Respostum.transaction do
        @formulario.questaos.each do |questao|
          respostum = Respostum.find_or_initialize_by(submissao: submissao, questao: questao)
          atribuir_valor(respostum, questao)
          respostum.save!
        end
      end
    end

    ##
    # Verifica se alguma questão do formulário deixou de receber valor.
    #
    # Não recebe argumentos explícitos; utiliza +@formulario+ e +@respostas_params+.
    #
    # Retorna +true+ quando ao menos uma resposta está em branco e +false+ caso contrário.
    #
    # Efeitos colaterais: carrega as questões do formulário quando necessário.
    def questao_em_branco?
      @formulario.questaos.any? { |questao| valor_para(questao).blank? }
    end

    ##
    # Obtém o valor enviado para uma questão específica.
    #
    # === Argumentos
    #
    # +questao+:: Questao cujo identificador será procurado nos parâmetros.
    #
    # === Retorno
    #
    # Retorna o valor enviado como String ou +nil+ quando ele não está presente.
    #
    # === Efeitos colaterais
    #
    # Não possui efeitos colaterais.
    def valor_para(questao)
      @respostas_params.dig(questao.id.to_s, "valor")
    end

    ##
    # Atribui o valor textual ou numérico correto conforme o tipo da questão.
    #
    # === Argumentos
    #
    # +respostum+:: Respostum que receberá o valor.
    # +questao+:: Questao que define o tipo e a origem do valor.
    #
    # === Retorno
    #
    # Retorna +nil+ após concluir as atribuições.
    #
    # === Efeitos colaterais
    #
    # Altera em memória +valor_texto+ e +valor_numerico+ da resposta; a persistência
    # ocorre posteriormente na ação #create.
    def atribuir_valor(respostum, questao)
      valor = valor_para(questao)

      if questao.tipo == "text"
        respostum.valor_texto = valor
        respostum.valor_numerico = nil
      else
        respostum.valor_numerico = valor
        respostum.valor_texto = nil
      end
    end
end
