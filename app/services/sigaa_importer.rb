# Serviço responsável pela importação e atualização de dados acadêmicos a partir
# dos arquivos JSON exportados pelo SIGAA (Sistema Integrado de Gestão de Atividades
# Acadêmicas).
#
# Processa dois arquivos: o de turmas/disciplinas (classes.json) e o de membros
# (class_members.json), criando ou atualizando +Departamento+s, +Disciplina+s,
# +Turma+s, +Docente+s, +Discente+s e +Curso+s dentro de uma única transação.
# Toda a lógica de persistência é encapsulada em métodos privados especializados,
# mantendo os métodos públicos enxutos.
#
# Os métodos de classe (+self.import_from_files+, +self.update_from_files+) são
# a interface pública recomendada; eles delegam para instâncias privadas para
# facilitar testes e reutilização interna.
class SigaaImporter
  DEFAULT_DEP_CODIGO = "NAO_ESP".freeze
  DEFAULT_DEP_NOME   = "Não especificado".freeze

  # Agrupa o hash de membro com a turma correspondente, eliminando a necessidade
  # de passar ambos como argumentos separados em todos os métodos de processamento.
  MemberEntry = Struct.new(:member_hash, :turma)

  # Importa disciplinas, turmas, docentes e discentes a partir dos arquivos JSON do SIGAA.
  #
  # Registros já existentes no banco de dados (identificados por código ou email/matrícula)
  # são ignorados; somente novos registros são criados.
  #
  # @param classes_path [String] caminho para o arquivo JSON com os dados das turmas/disciplinas
  # @param members_path [String] caminho para o arquivo JSON com os dados dos membros (docentes e discentes)
  # @return [String] mensagem descrevendo o resultado da operação
  def self.import_from_files(classes_path, members_path)
    new.import_from_files(classes_path, members_path)
  end

  # Executa a importação propriamente dita (método de instância delegado pelo class method).
  #
  # @param classes_path [String] caminho para o arquivo JSON de turmas/disciplinas
  # @param members_path [String] caminho para o arquivo JSON de membros
  # @return [String] mensagem de resultado da operação
  # @note Toda a operação roda dentro de uma transação; em caso de erro a transação
  #   é revertida e retorna "a importação falhou".
  def import_from_files(classes_path, members_path)
    counters = { created: 0, ignored: 0 }

    ActiveRecord::Base.transaction do
      dep_padrao
      import_classes_into(classes_path, counters)
      import_members_into(members_path, counters)
    end

    build_import_result(counters)
  rescue StandardError
    "a importação falhou"
  end

  # Atualiza disciplinas, turmas, docentes e discentes existentes a partir dos arquivos JSON do SIGAA.
  #
  # @param classes_path [String] caminho para o arquivo JSON com os dados das turmas/disciplinas
  # @param members_path [String] caminho para o arquivo JSON com os dados dos membros (docentes e discentes)
  # @return [String] mensagem descrevendo o resultado da operação
  def self.update_from_files(classes_path, members_path)
    new.update_from_files(classes_path, members_path)
  end

  # Executa a atualização propriamente dita (método de instância delegado pelo class method).
  #
  # @param classes_path [String] caminho para o arquivo JSON de turmas/disciplinas
  # @param members_path [String] caminho para o arquivo JSON de membros
  # @return [String] mensagem de resultado da operação
  # @note Toda a operação roda dentro de uma transação; em caso de erro a transação
  #   é revertida e retorna "a atualização falhou".
  def update_from_files(classes_path, members_path)
    ActiveRecord::Base.transaction do
      update_classes_from(classes_path)
      update_members_from(members_path)
    end

    "atualização realizada com sucesso"
  rescue StandardError
    "a atualização falhou"
  end

  private

  # Departamentos ------------------------------------------------------------

  # Retorna (ou cria na primeira chamada) o departamento padrão "Não especificado".
  #
  # @return [Departamento] instância memoizada do departamento padrão
  def dep_padrao
    @dep_padrao ||= Departamento.find_or_create_by!(codigo: DEFAULT_DEP_CODIGO) do |departamento|
      departamento.nome = DEFAULT_DEP_NOME
    end
  end

  # Localiza ou cria um departamento pelo nome informado.
  #
  # @param nome [String, nil] nome do departamento; se em branco, retorna o padrão
  # @return [Departamento] departamento encontrado ou recém-criado
  def find_or_create_departamento(nome)
    return dep_padrao if nome.blank?

    codigo = codigo_de_nome(nome, 20)
    Departamento.find_or_create_by!(codigo: codigo) { |dep| dep.nome = nome }
  end

  # Cursos -------------------------------------------------------------------

  # Localiza ou cria um curso pelo nome informado durante a importação.
  #
  # @param nome [String, nil] nome do curso; se em branco, retorna +nil+
  # @return [Curso, nil] curso encontrado ou recém-criado, ou +nil+ se nome ausente
  def find_or_create_curso(nome)
    return nil if nome.blank?

    codigo = codigo_de_nome(nome, 30)
    Curso.find_or_create_by!(codigo: codigo) do |curso|
      curso.nome = nome
      curso.departamento = dep_padrao
    end
  end

  # Localiza um curso existente pelo nome durante a atualização (não cria novo).
  #
  # @param nome [String, nil] nome do curso; se em branco, retorna +nil+
  # @return [Curso, nil] curso encontrado por código derivado ou por nome, ou +nil+
  def find_curso(nome)
    return nil if nome.blank?

    codigo = codigo_de_nome(nome, 30)
    Curso.find_by(codigo: codigo) || Curso.find_by(nome: nome)
  end

  # JSON parsing -------------------------------------------------------------

  # Lê e faz o parse de um arquivo JSON.
  #
  # @param path [String] caminho absoluto para o arquivo
  # @return [Array<Hash>] lista de entradas do JSON
  def parse_json(path)
    JSON.parse(File.read(path))
  end

  # Turma lookup -------------------------------------------------------------

  # Localiza a turma referenciada por um hash de membro do JSON.
  #
  # @param member_hash [Hash] entrada do JSON de membros contendo os dados da turma
  # @return [Turma, nil] turma encontrada, ou +nil+ se a disciplina ou turma não existir
  def lookup_turma(member_hash)
    code       = member_hash.dig("class", "code")       || member_hash["code"]
    class_code = member_hash.dig("class", "classCode")  || member_hash["classCode"]
    semester   = member_hash.dig("class", "semester")   || member_hash["semester"]

    disciplina = Disciplina.find_by(codigo: code)
    Turma.find_by(disciplina: disciplina, numero_da_turma: class_code, semestre: semester)
  end

  # Import classes -----------------------------------------------------------

  # Importa disciplinas e turmas a partir do arquivo JSON de classes.
  #
  # @param classes_path [String] caminho para o arquivo JSON de turmas/disciplinas
  # @param counters [Hash] hash com chaves +:created+ e +:ignored+ para contagem
  # @return [void]
  def import_classes_into(classes_path, counters)
    parse_json(classes_path).each do |entry|
      disciplina = find_or_create_disciplina(entry)
      turma = find_or_create_turma(disciplina, entry["class"] || {})

      if turma.created_at == turma.updated_at
        counters[:created] += 1
      else
        counters[:ignored] += 1
      end
    end
  end

  # Localiza ou cria uma disciplina a partir de uma entrada do JSON de classes.
  #
  # @param entry [Hash] entrada do JSON com as chaves "code" e "name"
  # @return [Disciplina] disciplina encontrada ou recém-criada
  def find_or_create_disciplina(entry)
    Disciplina.find_or_create_by!(codigo: entry["code"]) do |disciplina|
      disciplina.nome = entry["name"]
      disciplina.departamento = dep_padrao
    end
  end

  # Localiza ou cria uma turma para a disciplina a partir dos dados de classe.
  #
  # @param disciplina [Disciplina] disciplina à qual a turma pertence
  # @param class_info [Hash] hash com "classCode", "semester" e "time"
  # @return [Turma] turma encontrada ou recém-criada
  def find_or_create_turma(disciplina, class_info)
    Turma.find_or_create_by!(
      disciplina: disciplina,
      numero_da_turma: class_info["classCode"],
      semestre: class_info["semester"]
    ) do |turma|
      turma.horario = class_info["time"]
    end
  end

  # Update classes -----------------------------------------------------------

  # Atualiza disciplinas e turmas existentes a partir do arquivo JSON de classes.
  #
  # @param classes_path [String] caminho para o arquivo JSON de turmas/disciplinas
  # @return [void]
  # @note Apenas registros já existentes são atualizados; nenhum novo é criado.
  def update_classes_from(classes_path)
    parse_json(classes_path).each do |entry|
      disciplina = Disciplina.find_by(codigo: entry["code"])
      disciplina&.update(nome: entry["name"])

      class_info = entry["class"] || {}
      turma = Turma.find_by(
        disciplina: disciplina,
        numero_da_turma: class_info["classCode"],
        semestre: class_info["semester"]
      )
      turma&.update(horario: class_info["time"])
    end
  end

  # Import members (docentes + discentes) ------------------------------------

  # Importa docentes e discentes a partir do arquivo JSON de membros.
  #
  # @param members_path [String] caminho para o arquivo JSON de membros
  # @param counters [Hash] hash com chaves +:created+ e +:ignored+ para contagem
  # @return [void]
  def import_members_into(members_path, counters)
    parse_json(members_path).each do |member|
      turma = lookup_turma(member)
      next unless turma

      entry = MemberEntry.new(member, turma)
      import_docente(entry, counters)
      import_discentes(entry, counters)
    end
  end

  # Importa ou ignora o docente de uma entrada do JSON de membros.
  #
  # @param entry [MemberEntry] entrada com member_hash e turma
  # @param counters [Hash] hash de contagem +:created+/+:ignored+
  # @return [void]
  def import_docente(entry, counters)
    docente_hash = entry.member_hash["docente"]
    return unless docente_hash.is_a?(Hash)

    dep = find_or_create_departamento(docente_hash["departamento"])
    docente = find_or_create_docente(docente_hash, dep)
    add_membro_to_turma(docente, entry.turma, counters)
  end

  # Localiza ou cria um docente pelo email.
  #
  # @param docente_hash [Hash] hash com dados do docente (email, nome, matricula, formacao)
  # @param departamento [Departamento] departamento ao qual o docente pertence
  # @return [Docente] docente encontrado ou recém-criado
  def find_or_create_docente(docente_hash, departamento)
    Docente.find_or_create_by!(email: docente_hash["email"]) do |docente|
      docente.nome = docente_hash["nome"]
      docente.matricula = docente_hash["matricula"] || docente_hash["usuario"]
      docente.formacao = docente_hash["formacao"] || "docente"
      docente.departamento = departamento
    end
  end

  # Importa ou ignora os discentes de uma entrada do JSON de membros.
  #
  # @param entry [MemberEntry] entrada com member_hash e turma
  # @param counters [Hash] hash de contagem +:created+/+:ignored+
  # @return [void]
  def import_discentes(entry, counters)
    Array(entry.member_hash["dicente"]).each do |aluno|
      next unless aluno.is_a?(Hash)

      curso = find_or_create_curso(aluno["curso"])
      discente = find_or_create_discente(aluno, curso)
      add_membro_to_turma(discente, entry.turma, counters)
    end
  end

  # Localiza ou cria um discente pela matrícula.
  #
  # @param aluno_hash [Hash] hash com dados do aluno (matricula, nome, email, formacao)
  # @param curso [Curso, nil] curso ao qual o discente pertence
  # @return [Discente] discente encontrado ou recém-criado
  def find_or_create_discente(aluno_hash, curso)
    Discente.find_or_create_by!(matricula: aluno_hash["matricula"]) do |discente|
      discente.nome = aluno_hash["nome"]
      discente.email = aluno_hash["email"]
      discente.formacao = aluno_hash["formacao"] || "graduando"
      discente.curso = curso if curso
    end
  end

  # Update members -----------------------------------------------------------

  # Atualiza docentes e discentes existentes a partir do arquivo JSON de membros.
  #
  # @param members_path [String] caminho para o arquivo JSON de membros
  # @return [void]
  # @note Apenas registros já existentes são atualizados; nenhum novo é criado.
  def update_members_from(members_path)
    parse_json(members_path).each do |member|
      turma = lookup_turma(member)
      next unless turma

      entry = MemberEntry.new(member, turma)
      update_docente(entry)
      update_discentes(entry)
    end
  end

  # Atualiza o docente de uma entrada do JSON de membros, se ele já existir.
  #
  # @param entry [MemberEntry] entrada com member_hash e turma
  # @return [void]
  def update_docente(entry)
    docente_hash = entry.member_hash["docente"]
    return unless docente_hash.is_a?(Hash)

    dep = find_or_create_departamento(docente_hash["departamento"])
    docente = Docente.find_by(email: docente_hash["email"])
    return unless docente

    docente.update(
      nome: docente_hash["nome"],
      departamento: dep || docente.departamento
    )
    docente.turmas << entry.turma unless docente.turmas.exists?(entry.turma.id)
  end

  # Atualiza os discentes de uma entrada do JSON de membros, se eles já existirem.
  #
  # @param entry [MemberEntry] entrada com member_hash e turma
  # @return [void]
  def update_discentes(entry)
    Array(entry.member_hash["dicente"]).each do |aluno|
      next unless aluno.is_a?(Hash)

      curso = find_curso(aluno["curso"])
      discente = Discente.find_by(matricula: aluno["matricula"])
      next unless discente

      discente.update(
        nome: aluno["nome"],
        email: aluno["email"],
        curso: curso || discente.curso
      )
      discente.turmas << entry.turma unless discente.turmas.exists?(entry.turma.id)
    end
  end

  # Helpers ------------------------------------------------------------------

  # Adiciona um membro (docente ou discente) a uma turma, incrementando os contadores.
  #
  # @param membro [Docente, Discente] membro a ser adicionado
  # @param turma [Turma] turma alvo
  # @param counters [Hash] hash de contagem +:created+/+:ignored+
  # @return [void]
  def add_membro_to_turma(membro, turma, counters)
    if membro.turmas.exists?(turma.id)
      counters[:ignored] += 1
    else
      membro.turmas << turma
      counters[:created] += 1
    end
  end

  # Deriva um código curto a partir de um nome por parametrização e truncamento.
  #
  # @param nome [String] nome a converter
  # @param max_length [Integer] número máximo de caracteres do código
  # @return [String] código em maiúsculas com separadores underline
  def codigo_de_nome(nome, max_length)
    nome.parameterize(separator: "_").upcase.first(max_length)
  end

  # Constrói a mensagem de resultado da importação com base nos contadores.
  #
  # @param counters [Hash] hash com as chaves +:created+ e +:ignored+
  # @return [String] mensagem descritiva do resultado
  def build_import_result(counters)
    created = counters[:created]
    if created > 0 && counters[:ignored] > 0
      "alguns dados já foram importados e não serão importados novamente, mas os dados restantes foram importados com sucesso"
    elsif created == 0
      "os dados já existem e não foram duplicados"
    else
      "importação realizada com sucesso"
    end
  end
end
