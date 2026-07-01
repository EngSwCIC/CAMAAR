##
# Serviços relacionados à criação e ao gerenciamento de formulários.
module Formularios
  ##
  # Cria um formulário e copia as questões do template selecionado para manter
  # uma versão independente da avaliação.
  class CreateFromTemplate
    # Resultado imutável contendo o formulário processado e o estado da operação.
    Result = Data.define(:formulario, :success?)

    ##
    # Inicializa o serviço com o administrador e os atributos do formulário.
    #
    # === Argumentos
    #
    # +admin:+:: User administrador responsável pelo novo formulário.
    # +params:+:: Hash ou ActionController::Parameters com os atributos permitidos.
    #
    # === Retorno
    #
    # Retorna uma nova instância de Formularios::CreateFromTemplate.
    #
    # === Efeitos colaterais
    #
    # Armazena os argumentos em memória; não persiste registros.
    def initialize(admin:, params:)
      @admin = admin
      @params = params
    end

    ##
    # Persiste o formulário e clona as questões quando os dados são válidos.
    #
    # Não recebe argumentos.
    #
    # Retorna Result com o Formulario processado e +success?+ igual a +true+ ou +false+.
    #
    # Efeitos colaterais: cria o formulário e suas questões no banco quando as
    # validações são satisfeitas.
    def call
      formulario = Formulario.new(@params)
      formulario.admin = @admin
      formulario.target_role = template&.target_role

      if formulario.save
        clone_questoes(formulario)
        Result.new(formulario:, success?: true)
      else
        Result.new(formulario:, success?: false)
      end
    end

    private

    ##
    # Localiza o template selecionado nos parâmetros do serviço.
    #
    # Não recebe argumentos.
    #
    # Retorna o Template encontrado ou +nil+ quando o identificador é inválido.
    #
    # Efeitos colaterais: consulta o banco de dados.
    def template
      Template.find_by(id: @params[:template_id])
    end

    ##
    # Copia para o formulário todas as questões do template selecionado.
    #
    # === Argumentos
    #
    # +formulario+:: Formulario que receberá as novas questões.
    #
    # === Retorno
    #
    # Retorna a coleção de questões percorrida ou +nil+ quando não existe template.
    #
    # === Efeitos colaterais
    #
    # Cria uma Questao no banco para cada questão do template e pode lançar uma
    # exceção de persistência.
    def clone_questoes(formulario)
      template&.questaos&.each do |questao|
        formulario.questaos.create!(enunciado: questao.enunciado, tipo: questao.tipo)
      end
    end
  end
end
