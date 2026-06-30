require "set"

##
# Serviço de importação dos dados do SIGAA no formato JSON (listas +classes+ e
# +members+). Cria turmas, usuários (discentes e docentes) e matrículas de forma
# idempotente: rodar duas vezes com os mesmos dados não duplica registros.
class SigaaImporter
  ##
  # a. Descrição: Ponto de entrada do serviço; importa turmas, usuários e matrículas do SIGAA.
  # b. Argumentos: 'classes' (Array de Hash) e 'members' (Array de Hash) no formato do SIGAA.
  # c. Retorno: Hash com as contagens processadas { turmas:, users:, enrollments: }.
  # d. Efeitos colaterais: Cria/atualiza registros de Turma, User e Enrollment no banco de dados.
  def self.call(classes:, members:)
    new(classes, members).call
  end

  ##
  # a. Descrição: Inicializa o serviço com os dados a importar e os acumuladores de contagem.
  # b. Argumentos: 'classes' (Array) e 'members' (Array); valores nulos viram arrays vazios.
  # c. Retorno: Uma nova instância de SigaaImporter.
  # d. Efeitos colaterais: Nenhum.
  def initialize(classes, members)
    @classes = Array(classes)
    @members = Array(members)
    @turmas = {}
    @user_ids = Set.new
    @enrollment_ids = Set.new
  end

  ##
  # a. Descrição: Executa a importação completa (primeiro as turmas, depois os membros).
  # b. Argumentos: Nenhum.
  # c. Retorno: Hash com as contagens de turmas, users e enrollments processados.
  # d. Efeitos colaterais: Persiste registros de Turma, User e Enrollment no banco de dados.
  def call
    @classes.each { |turma_data| importar_turma(turma_data) }
    @members.each { |membro_data| importar_membros_da_turma(membro_data) }
    { turmas: @turmas.size, users: @user_ids.size, enrollments: @enrollment_ids.size }
  end

  private

  ##
  # a. Descrição: Cria/recupera uma turma a partir de um item da lista +classes+.
  # b. Argumentos: 'turma_data' (Hash) com 'code', 'name' e o sub-hash 'class'.
  # c. Retorno: Não há (armazena a turma no índice interno).
  # d. Efeitos colaterais: Insere uma Turma no banco caso ainda não exista.
  def importar_turma(turma_data)
    turma_class = turma_data["class"] || {}
    code = turma_data["code"]
    class_code = turma_class["classCode"]
    semester = turma_class["semester"]

    turma = Turma.find_or_create_by!(code: code, class_code: class_code, semester: semester) do |nova_turma|
      nova_turma.name = turma_data["name"]
    end
    @turmas[chave_turma(code, class_code, semester)] = turma
  end

  ##
  # a. Descrição: Matricula os discentes e o docente de um item da lista +members+ na sua turma.
  # b. Argumentos: 'membro_data' (Hash) com 'code', 'classCode', 'semester', 'dicente' e 'docente'.
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Cria usuários e matrículas no banco de dados.
  def importar_membros_da_turma(membro_data)
    turma = turma_do_membro(membro_data)
    return if turma.nil?

    Array(membro_data["dicente"]).each { |pessoa| matricular(turma, pessoa, "discente") }
    docente = membro_data["docente"]
    matricular(turma, docente, "docente") if docente.present?
  end

  ##
  # a. Descrição: Localiza a turma associada a um item de +members+ (índice interno ou banco).
  # b. Argumentos: 'membro_data' (Hash) com 'code', 'classCode' e 'semester'.
  # c. Retorno: Retorna a Turma encontrada ou nil.
  # d. Efeitos colaterais: Nenhum.
  def turma_do_membro(membro_data)
    code = membro_data["code"]
    class_code = membro_data["classCode"]
    semester = membro_data["semester"]

    @turmas[chave_turma(code, class_code, semester)] ||
      Turma.find_by(code: code, class_code: class_code, semester: semester)
  end

  ##
  # a. Descrição: Garante o usuário e a matrícula de uma pessoa na turma, contabilizando ambos.
  # b. Argumentos: 'turma' (Turma), 'pessoa' (Hash) e 'perfil' (String "discente"/"docente").
  # c. Retorno: Nenhum.
  # d. Efeitos colaterais: Cria User e Enrollment no banco e atualiza os acumuladores de contagem.
  def matricular(turma, pessoa, perfil)
    user = User.find_or_invite_from_pessoa(pessoa, perfil)
    @user_ids << user.id
    @enrollment_ids << Enrollment.ensure_role(user: user, turma: turma, perfil: perfil).id
  end

  ##
  # a. Descrição: Monta a chave única que identifica uma turma (código, turma e semestre).
  # b. Argumentos: 'code', 'class_code' e 'semester'.
  # c. Retorno: Retorna um Array usado como chave do índice de turmas.
  # d. Efeitos colaterais: Nenhum.
  def chave_turma(code, class_code, semester)
    [ code, class_code, semester ]
  end
end
