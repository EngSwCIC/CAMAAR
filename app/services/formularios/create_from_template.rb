module Formularios
  # Cria formulários a partir de um template e de uma lista de turmas.
  #
  # A classe valida o template, as turmas e o público-alvo antes de criar os
  # formulários, copiar as questões como snapshot e gerar avaliações pendentes.
  class CreateFromTemplate
    # Mensagem quando a lista de turmas está vazia.
    SEM_TURMAS = "É necessário selecionar pelo menos uma turma"

    # Mensagem quando nenhum template foi informado.
    SEM_TEMPLATE = "Selecione um template"

    # Mensagem quando o template não possui questões.
    SEM_QUESTOES = "O template deve possuir pelo menos uma questão"

    # Mensagem quando algum id de turma não existe no banco.
    TURMAS_INVALIDAS = "Uma ou mais turmas selecionadas são inválidas"

    # Mensagem quando turma, template e público-alvo já possuem formulário.
    TURMA_COM_FORMULARIO = "Uma ou mais turmas selecionadas já possuem formulário para este template e público-alvo"

    # Mensagem quando alguma turma pertence a outro departamento do administrador.
    TURMA_DEPARTAMENTO_INCOMPATIVEL = "Uma ou mais turmas selecionadas pertencem a outro departamento"

    # Mensagem quando o público-alvo não foi selecionado.
    SEM_PUBLICO_ALVO = "Por favor, selecione o público-alvo do formulário"

    ##
    # Executa a criação de formulários a partir de um template.
    #
    # Argumentos:
    # - +template_id+: id do template usado como origem.
    # - +turma_ids+: lista de ids das turmas que receberão formulário.
    # - +publico_alvo+: público que deve responder ao formulário.
    # - +perfil_adm+: administrador responsável pela criação.
    #
    # Retorno:
    # - Retorna uma lista de formulários criados.
    # - Levanta +Formularios::Error+ quando alguma validação de negócio falha.
    #
    # Efeitos colaterais:
    # - Insere formulários no banco de dados.
    # - Copia questões e opções do template para cada formulário.
    # - Cria avaliações pendentes para o público-alvo selecionado.
    def self.call(template_id:, turma_ids:, publico_alvo:, perfil_adm:)
      new(template_id:, turma_ids:, publico_alvo:, perfil_adm:).call
    end

    ##
    # Valida se o template e as turmas permitem preparar a publicação.
    #
    # Argumentos:
    # - +template_id+: id do template que será usado.
    # - +turma_ids+: lista de ids das turmas selecionadas.
    # - +perfil_adm+: administrador que tenta preparar os formulários.
    #
    # Retorno:
    # - Retorna +nil+ quando todas as validações passam.
    # - Levanta +Formularios::Error+ quando alguma validação falha.
    #
    # Efeitos colaterais:
    # - Consulta o banco de dados.
    # - Não cria nem altera registros.
    def self.validate_preparacao!(template_id:, turma_ids:, perfil_adm:)
      new(template_id:, turma_ids:, publico_alvo: :docentes, perfil_adm:).validate_preparacao!
    end

    ##
    # Inicializa o serviço com os dados necessários para criar formulários.
    #
    # Argumentos:
    # - +template_id+: id do template de origem.
    # - +turma_ids+: ids das turmas selecionadas; valores duplicados e zero são
    #   normalizados.
    # - +publico_alvo+: público-alvo escolhido para os formulários.
    # - +perfil_adm+: administrador que está executando a ação.
    #
    # Retorno:
    # - Retorna a instância inicializada.
    #
    # Efeitos colaterais:
    # - Normaliza +turma_ids+ em memória.
    # - Não consulta nem altera o banco de dados.
    def initialize(template_id:, turma_ids:, publico_alvo:, perfil_adm:)
      @template_id = template_id
      @turma_ids = Array(turma_ids).map(&:to_i).uniq.reject(&:zero?)
      @publico_alvo = publico_alvo
      @perfil_adm = perfil_adm
    end

    ##
    # Valida os pré-requisitos para publicar formulários a partir do template.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa os dados recebidos no inicializador.
    #
    # Retorno:
    # - Retorna +nil+ quando todas as validações passam.
    # - Levanta +Formularios::Error+ em caso de template/turmas inválidos.
    #
    # Efeitos colaterais:
    # - Consulta o banco de dados.
    # - Não cria nem altera registros.
    def validate_preparacao!
      validate_turma_ids
      validate_template
      validate_turmas
      validate_turmas_sem_formulario
    end

    ##
    # Executa a criação completa dos formulários.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa os dados recebidos no inicializador.
    #
    # Retorno:
    # - Retorna uma lista de formulários criados.
    # - Levanta +Formularios::Error+ ou exceções ActiveRecord se algo falhar.
    #
    # Efeitos colaterais:
    # - Cria formulários, questões copiadas, opções copiadas e avaliações
    #   pendentes no banco de dados.
    # - Executa as alterações dentro de transação.
    def call
      validate_preparacao!
      validate_publico_alvo

      create_formularios
    end

    private

    attr_reader :template_id, :turma_ids, :publico_alvo, :perfil_adm

    ##
    # Cria um formulário para cada turma selecionada.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa +turmas+ e os demais dados do serviço.
    #
    # Retorno:
    # - Retorna uma lista de formulários criados.
    #
    # Efeitos colaterais:
    # - Insere formulários e seus dados derivados dentro de uma transação.
    # - Reverte tudo se alguma criação falhar.
    def create_formularios
      ActiveRecord::Base.transaction do
        turmas.map { |turma| create_formulario(turma) }
      end
    end

    ##
    # Cria um formulário para uma turma específica.
    #
    # Argumentos:
    # - +turma+: turma que receberá o formulário.
    #
    # Retorno:
    # - Retorna o formulário criado.
    #
    # Efeitos colaterais:
    # - Insere um formulário no banco.
    # - Copia questões/opções do template para o formulário.
    # - Cria avaliações pendentes para a turma.
    def create_formulario(turma)
      Formulario.create!(
        adm: perfil_adm,
        template: template,
        turma: turma,
        publico_alvo: publico_alvo
      ).tap do |formulario|
        TemplateQuestionSnapshot.copy(template: template, formulario: formulario)
        formulario.criar_avaliacoes_pendentes!
      end
    end

    ##
    # Valida se há pelo menos uma turma selecionada.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa +turma_ids+.
    #
    # Retorno:
    # - Retorna +nil+ quando há turmas.
    # - Levanta +Formularios::Error+ quando a lista está vazia.
    #
    # Efeitos colaterais:
    # - Não consulta nem altera o banco de dados.
    def validate_turma_ids
      raise Error, SEM_TURMAS if turma_ids.empty?
    end

    ##
    # Valida se o template possui questões publicáveis.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa o template carregado pelo serviço.
    #
    # Retorno:
    # - Retorna +nil+ quando o template possui questões raiz.
    # - Levanta +Formularios::Error+ quando não há questões.
    #
    # Efeitos colaterais:
    # - Consulta o banco de dados.
    # - Não altera registros.
    def validate_template
      raise Error, SEM_QUESTOES if template.utilizacoes_questoes.raizes.none?
    end

    ##
    # Valida se todas as turmas informadas existem no escopo do administrador.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa +turma_ids+ e +turmas+.
    #
    # Retorno:
    # - Retorna +nil+ quando todas as turmas são válidas.
    # - Levanta +Formularios::Error+ quando alguma turma não é encontrada.
    #
    # Efeitos colaterais:
    # - Consulta o banco de dados.
    # - Não altera registros.
    def validate_turmas
      raise Error, TURMAS_INVALIDAS if turmas.count != turma_ids.size
    end

    ##
    # Valida se as turmas selecionadas ainda não possuem formulário para o
    # mesmo template e público-alvo.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa +turmas+.
    #
    # Retorno:
    # - Retorna +nil+ quando nenhuma turma possui formulário.
    # - Levanta +Formularios::Error+ quando encontra formulário existente.
    #
    # Efeitos colaterais:
    # - Consulta o banco de dados.
    # - Não altera registros.
    def validate_turmas_sem_formulario
      raise Error, TURMA_COM_FORMULARIO if formulario_duplicado?
    end

    def formulario_duplicado?
      Formulario
        .where(turma_id: turmas.select(:id))
        .where(template_id: template_id, publico_alvo: publico_alvo)
        .exists?
    end

    ##
    # Valida se o público-alvo foi informado e é aceito pelo modelo.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa +publico_alvo+.
    #
    # Retorno:
    # - Retorna +nil+ quando o público-alvo é válido.
    # - Levanta +Formularios::Error+ quando está em branco ou é inválido.
    #
    # Efeitos colaterais:
    # - Não altera registros.
    def validate_publico_alvo
      raise Error, SEM_PUBLICO_ALVO unless publico_alvo_valido?
    end

    ##
    # Informa se o público-alvo é válido para formulários.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa +publico_alvo+.
    #
    # Retorno:
    # - Retorna +true+ quando o público-alvo está presente e existe no enum de
    #   +Formulario+.
    # - Retorna +false+ quando está em branco ou não é reconhecido.
    #
    # Efeitos colaterais:
    # - Não consulta nem altera o banco de dados.
    def publico_alvo_valido?
      publico_alvo.present? && Formulario.publico_alvos.key?(publico_alvo.to_s)
    end

    ##
    # Carrega o template de origem.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa +template_id+.
    #
    # Retorno:
    # - Retorna o template encontrado e memoizado.
    # - Levanta exceção se o template não existir.
    #
    # Efeitos colaterais:
    # - Consulta o banco de dados na primeira chamada.
    # - Memoiza o resultado em +@template+.
    def template
      @template ||= Template.find(template_id)
    end

    ##
    # Carrega as turmas válidas para o administrador e semestre atual.
    #
    # Argumentos:
    # - Não recebe argumentos. Usa +perfil_adm+ e +turma_ids+.
    #
    # Retorno:
    # - Retorna uma relação de +Turma+ filtrada por departamento, semestre e
    #   ids selecionados.
    #
    # Efeitos colaterais:
    # - Pode consultar o banco de dados quando a relação é avaliada.
    # - Memoiza a relação em +@turmas+.
    def turmas
      @turmas ||= Turma
        .do_departamento(perfil_adm.departamento)
        .do_semestre_atual
        .where(id: turma_ids)
    end
  end
end
