# Responsável por importar disciplinas, turmas e usuários
# a partir dos arquivos JSON exportados do SIGAA.
class ImportDataService

  CLASSES_PATH = Rails.root.join('..', '..', 'classes.json').freeze
  MEMBERS_PATH = Rails.root.join('..', '..', 'class_members.json').freeze

  # Executa a importação completa de disciplinas, turmas e usuários.
  #
  # Não recebe argumentos. Possui duas possibilidades de retorno:
  # { success: true } quando a importação é concluída;
  # { success: false, error: 'mensagem' } quando os arquivos
  #   não existem ou o JSON é inválido.
  # Efeito colateral: pode persistir registros de Disciplina, Turma,
  # User e TurmaAluno no banco de dados.
  def self.import_all
    return arquivos_ausentes unless files_exist?

    classes_data, members_data = load_json_files
    importar_dados(classes_data, members_data)

    { success: true }
  rescue JSON::ParserError
    { success: false, error: 'Erro ao ler os arquivos JSON' }
  end

  private

  # Verifica se os arquivos JSON do SIGAA existem no caminho configurado.
  #
  # Não recebe argumentos. Retorna true se ambos os arquivos existem,
  # false caso contrário. Não altera o banco de dados.
  def self.files_exist?
    File.exist?(CLASSES_PATH) && File.exist?(MEMBERS_PATH)
  end

  # Retorna o hash de erro padrão para arquivos ausentes.
  #
  # Não recebe argumentos. Retorna
  # { success: false, error: 'Arquivos não localizados' }.
  # Não altera o banco de dados.
  def self.arquivos_ausentes
    { success: false, error: 'Arquivos não localizados' }
  end

  # Lê e parseia os dois arquivos JSON do SIGAA.
  #
  # Não recebe argumentos. Retorna um +Array+ com dois elementos:
  # o conteúdo parseado de +classes.json+ e de +class_members.json+.
  # Levanta +JSON::ParserError+ se algum arquivo for inválido.
  # Não altera o banco de dados.
  def self.load_json_files
    [
      JSON.parse(File.read(CLASSES_PATH)),
      JSON.parse(File.read(MEMBERS_PATH))
    ]
  end

  # Orquestra a importação de disciplinas, turmas e usuários.
  #
  # Recebe +classes_data+ (Array de hashes) e +members_data+ (Array de hashes).
  # Não retorna valor relevante. Efeito colateral: delega persistência para
  # +import_disciplinas_classes+ e +import_users_members+.
  def self.importar_dados(classes_data, members_data)
    import_disciplinas_classes(classes_data)
    import_users_members(members_data)
  end

  # Importa disciplinas e turmas a partir dos dados de classes.
  #
  # Recebe +classes_data+ (Array de hashes com dados de disciplina e turma).
  # Não retorna valor relevante. Efeito colateral: pode criar registros de
  # +Disciplina+ e +Turma+ no banco de dados.
  def self.import_disciplinas_classes(classes_data)
    classes_data.each do |class_data|
      disciplina = import_disciplina(class_data)
      import_turma(class_data, disciplina)
    end
  end

  # Importa ou encontra uma disciplina a partir dos dados informados.
  #
  # Recebe +class_data+ (Hash com chaves 'code' e 'name'). Retorna a
  # instância de +Disciplina+ encontrada ou criada. Efeito colateral:
  # pode criar um registro de +Disciplina+ no banco de dados.
  def self.import_disciplina(class_data)
    codigo = class_data['code']
    Disciplina.find_or_create_by(codigo: codigo) do |disciplina|
      disciplina.nome       = class_data['name']
      disciplina.department = codigo.gsub(/[0-9]/, '').strip
    end
  end

  # Importa ou encontra uma turma a partir dos dados informados.
  #
  # Recebe +class_data+ (Hash com chave 'class' contendo 'classCode',
  # 'semester' e 'time') e +disciplina+ (instância de +Disciplina+).
  # Retorna a instância de +Turma+ encontrada ou criada. Efeito colateral:
  # pode criar um registro de +Turma+ no banco de dados.
  def self.import_turma(class_data, disciplina)
    turma_info = class_data['class']
    Turma.find_or_create_by(
      codigo:     turma_info['classCode'],
      semestre:   turma_info['semester'],
      disciplina: disciplina
    ) do |turma|
      turma.horario = turma_info['time']
    end
  end

  # Importa membros (discentes e docentes) para cada turma.
  #
  # Recebe +members_data+ (Array de hashes com dados de membros).
  # Não retorna valor relevante. Efeito colateral: delega criação de
  # usuários e vínculos a +import_member+.
  def self.import_users_members(members_data)
    members_data.each { |member_data| import_member(member_data) }
  end

  # Importa os membros de um único registro de turma.
  #
  # Recebe +member_data+ (Hash com 'classCode', 'semester', 'dicente'
  # e 'docente'). Retorna +nil+ se a turma não for encontrada.
  # Efeito colateral: pode criar registros de +User+ e +TurmaAluno+.
  def self.import_member(member_data)
    turma = Turma.find_by(
      codigo:   member_data['classCode'],
      semestre: member_data['semester']
    )
    return unless turma

    docente = member_data['docente']
    import_dicentes(member_data['dicente'] || [], turma)
    import_teacher(docente, turma) if docente.present?
  end

  # Importa os discentes de uma turma.
  #
  # Recebe +dicentes+ (Array de hashes com dados dos alunos) e +turma+
  # (instância de +Turma+). Não retorna valor relevante.
  # Efeito colateral: pode criar registros de +User+ e +TurmaAluno+.
  def self.import_dicentes(dicentes, turma)
    dicentes.each { |aluno_data| import_student(aluno_data, turma) }
  end

  # Importa ou encontra um aluno e cria seu vínculo com a turma.
  #
  # Recebe +aluno_data+ (Hash com 'matricula', 'nome', 'email', 'curso')
  # e +turma+ (instância de +Turma+). Retorna a instância de +TurmaAluno+
  # encontrada ou criada. Efeito colateral: pode criar registros de
  # +User+ e +TurmaAluno+ no banco de dados.
  def self.import_student(aluno_data, turma)
    matricula = aluno_data['matricula']
    user      = User.find_by(matricula: matricula) || create_student(aluno_data, matricula)
    TurmaAluno.find_or_create_by(turma: turma, aluno_id: user.id)
  end

  # Cria um novo usuário com perfil de discente.
  #
  # Recebe +aluno_data+ (Hash com 'nome', 'email', 'curso') e +matricula+
  # (String). Retorna a instância de +User+ criada. Efeito colateral:
  # persiste um registro de +User+ no banco de dados com +first_access: true+
  # e senha temporária gerada aleatoriamente.
  def self.create_student(aluno_data, matricula)
    curso = aluno_data['curso'] || ''
    User.create!(
      matricula:    matricula,
      name:         aluno_data['nome'],
      email:        aluno_data['email'],
      role:         'user',
      department:   curso.split('/').last,
      first_access: true,
      password:     SecureRandom.hex(16)
    )
  end

  # Importa ou encontra um docente pelo e-mail.
  #
  # Recebe +docente_data+ (Hash com 'email', 'nome', 'usuario') e
  # +turma+ (instância de +Turma+). Retorna a instância de +User+
  # encontrada ou criada. Efeito colateral: pode criar um registro
  # de +User+ no banco de dados.
  def self.import_teacher(docente_data, turma)
    email = docente_data['email']
    User.find_by(email: email) || create_teacher(docente_data, email, turma)
  end

  # Cria um novo usuário com perfil de administrador (docente).
  #
  # Recebe +docente_data+ (Hash com 'usuario', 'nome'), +email+ (String)
  # e +turma+ (instância de +Turma+). Retorna a instância de +User+ criada.
  # Efeito colateral: persiste um registro de +User+ no banco de dados com
  # +role: 'admin'+, +first_access: true+ e senha temporária aleatória.
  def self.create_teacher(docente_data, email, turma)
    User.create!(
      matricula:    docente_data['usuario'],
      name:         docente_data['nome'],
      email:        email,
      role:         'admin',
      department:   turma.disciplina.department,
      first_access: true,
      password:     SecureRandom.hex(16)
    )
  end
end