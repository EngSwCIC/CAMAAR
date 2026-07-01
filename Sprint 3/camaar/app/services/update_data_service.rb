# Responsável por atualizar os dados das disciplinas,
# turmas e usuários a partir dos arquivos JSON fornecidos.
class UpdateDataService

  CLASSES_PATH = Rails.root.join('..', '..', 'classes.json').freeze
  MEMBERS_PATH = Rails.root.join('..', '..', 'class_members.json').freeze

  # Executa a atualização de todos os registros a partir dos arquivos JSON.
  #
  # Não recebe argumentos. Possui duas possibilidades de retorno:
  # { success: true, updated: true, message: '...' } quando
  #   há registros alterados;
  # { success: true, updated: false, message: '...' } quando
  #   a base já está sincronizada;
  # { success: false, error: 'mensagem' } quando os arquivos
  #   não existem ou o JSON é inválido.
  # Efeito colateral: pode atualizar registros de +Disciplina+, +Turma+
  # e +User+ no banco de dados.
  def self.update_all
    return arquivos_ausentes unless files_exist?

    classes_data, members_data = load_json_files
    updated_records = contar_atualizacoes(classes_data, members_data)

    success_response(updated_records)
  rescue JSON::ParserError
    { success: false, error: 'Erro ao ler os arquivos JSON' }
  end

  private

  # Soma o total de registros atualizados em disciplinas, turmas e usuários.
  #
  # Recebe classes_data e members_data (Arrays de hashes).
  # Retorna um Integer com o total de registros alterados.
  # Efeito colateral: delega persistência para os métodos de atualização.
  def self.contar_atualizacoes(classes_data, members_data)
    update_disciplinas_classes(classes_data) +
      update_users_members(members_data)
  end

  # Atualiza disciplinas e turmas a partir dos dados de classes.
  #
  # Recebe classes_data (Array de hashes). Retorna um Integer com
  # o total de registros de Disciplina e Turma alterados.
  # Efeito colateral: pode atualizar registros no banco de dados.
  def self.update_disciplinas_classes(classes_data)
    classes_data.sum do |class_data|
      update_disciplina(class_data) + update_turma(class_data)
    end
  end

  # Atualiza usuários (discentes e docentes) a partir dos dados de membros.
  #
  # Recebe members_data (Array de hashes). Retorna um Integer com
  # o total de registros de User alterados.
  # Efeito colateral: pode atualizar registros no banco de dados.
  def self.update_users_members(members_data)
    members_data.sum do |member_data|
      update_dicentes(member_data) + update_docente(member_data)
    end
  end

  # Verifica se os arquivos JSON do SIGAA existem no caminho configurado.
  #
  # Não recebe argumentos. Retorna +true+ se ambos os arquivos existem,
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
  # Não recebe argumentos. Retorna um Array com dois elementos:
  # o conteúdo parseado de classes.json e de class_members.json.
  # Levanta JSON::ParserError se algum arquivo for inválido.
  # Não altera o banco de dados.
  def self.load_json_files
    [
      JSON.parse(File.read(CLASSES_PATH)),
      JSON.parse(File.read(MEMBERS_PATH))
    ]
  end

  # Monta o hash de resposta de sucesso com base na quantidade de atualizações.
  #
  # Recebe updated_records (Integer). Retorna
  # { success: true, updated: false, message: '...' } quando zero,
  # ou { success: true, updated: true, message: '...' } quando
  # há registros alterados. Não altera o banco de dados.
  def self.success_response(updated_records)
    if updated_records.zero?
      { success: true, updated: false, message: 'Não há novos dados para atualização' }
    else
      { success: true, updated: true,  message: 'Dados atualizados com sucesso' }
    end
  end

  # Atualiza os atributos de uma disciplina se houver alterações.
  #
  # Recebe class_data (Hash com 'code' e 'name'). Retorna 1 se o
  # registro foi alterado e salvo, 0 caso contrário.
  # Efeito colateral: pode criar ou atualizar um registro de +Disciplina+.
  def self.update_disciplina(class_data)
    codigo     = class_data['code']
    disciplina = Disciplina.find_or_initialize_by(codigo: codigo)
    disciplina.assign_attributes(
      nome:       class_data['name'],
      department: codigo.gsub(/[0-9]/, '').strip
    )
    save_if_changed(disciplina)
  end

  # Atualiza os atributos de uma turma se houver alterações.
  #
  # Recebe class_data (Hash com chave 'class' contendo 'classCode',
  # 'semester' e 'time'). Retorna 1 se o registro foi alterado e salvo,
  # 0 caso contrário. Efeito colateral: pode criar ou atualizar um
  # registro de Turma.
  def self.update_turma(class_data)
    turma_info = class_data['class']
    disciplina = Disciplina.find_by(codigo: class_data['code'])
    turma      = Turma.find_or_initialize_by(
      codigo:     turma_info['classCode'],
      semestre:   turma_info['semester'],
      disciplina: disciplina
    )
    turma.assign_attributes(horario: turma_info['time'])
    save_if_changed(turma)
  end

  # Atualiza os discentes de um registro de membro.
  #
  # Recebe member_data (Hash com chave 'dicente' contendo Array de hashes).
  # Retorna um Integer com o total de discentes atualizados.
  # Efeito colateral: pode atualizar registros de User.
  def self.update_dicentes(member_data)
    (member_data['dicente'] || []).sum { |aluno_data| update_dicente(aluno_data) }
  end

  # Atualiza os atributos de um discente se houver alterações.
  #
  # Recebe aluno_data (Hash com 'matricula', 'nome', 'email', 'curso').
  # Retorna 1 se o registro foi alterado, 0 se não houver mudanças ou
  # o usuário não for encontrado. Efeito colateral: pode atualizar um
  # registro de User no banco de dados.
  def self.update_dicente(aluno_data)
    user = User.find_by(matricula: aluno_data['matricula'])
    return 0 unless user

    curso = aluno_data['curso'] || ''
    user.assign_attributes(
      name:       aluno_data['nome'],
      email:      aluno_data['email']&.downcase,
      department: curso.split('/').last
    )
    save_if_changed(user)
  end

  # Atualiza os atributos de um docente se houver alterações.
  #
  # Recebe +member_data+ (Hash com chave 'docente' contendo 'usuario',
  # 'nome' e 'email'). Retorna +1+ se o registro foi alterado, +0+ se
  # não houver docente, usuário não encontrado ou sem mudanças.
  # Efeito colateral: pode atualizar um registro de +User+ no banco de dados.
  def self.update_docente(member_data)
    docente = member_data['docente']
    return 0 unless docente

    user = User.find_by(matricula: docente['usuario'])
    return 0 unless user

    user.assign_attributes(
      name:  docente['nome'],
      email: docente['email']&.downcase
    )
    save_if_changed(user)
  end

  # Persiste o registro se ele for novo ou tiver atributos alterados.
  #
  # Recebe record (instância de qualquer model ActiveRecord).
  # Retorna 1 se o registro foi salvo, +0+ caso contrário.
  # Efeito colateral: pode persistir alterações no banco de dados.
  # Levanta exceção em caso de falha de validação (+ActiveRecord::RecordInvalid+).
  def self.save_if_changed(record)
    return 0 unless record.new_record? || record.changed?

    record.save!
    1
  end
end