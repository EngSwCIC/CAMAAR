class ImportDataService

  def self.import_all
    begin
      classes_path = Rails.root.join('..', '..', 'classes.json')
      members_path = Rails.root.join('..', '..', 'class_members.json')

      json_exists = File.exist?(classes_path) &&
                    File.exist?(members_path)

      unless json_exists
        return {
          success: false,
          error: 'Arquivos não localizados'
        }
      end

      classes_data = JSON.parse(File.read(classes_path))
      members_data = JSON.parse(File.read(members_path))

      import_disciplinas_classes(classes_data)

      import_users_members(members_data)

      { success: true }

    rescue JSON::ParserError
      {
        success: false,
        error: 'Erro ao ler os arquivos JSON'
      }
    end
  end

  private

  def self.import_disciplinas_classes(classes_data)

    classes_data.each do |class_data|

      department = class_data['code'].gsub(/[0-9]/, '').strip

      disciplina = Disciplina.find_or_create_by(
        codigo: class_data['code']
      ) do |d|
        d.nome = class_data['name']
        d.department = department
      end

      turma_info = class_data['class']

      Turma.find_or_create_by(
        codigo: turma_info['classCode'],
        semestre: turma_info['semester'],
        disciplina: disciplina
      ) do |t|
        t.horario = turma_info['time']
        t.disciplina = disciplina
      end
    end
  end

  def self.import_users_members(members_data)

    members_data.each do |member_data|

      turma = Turma.find_by(
        codigo: member_data['classCode'],
        semestre: member_data['semester']
      )

      next unless turma

      (member_data['dicente'] || []).each do |aluno_data|
        import_student(aluno_data, turma)
      end

      docente_data = member_data['docente']

      import_teacher(docente_data, turma) if docente_data.present?
    end
  end

  def self.import_student(aluno_data, turma)
    user = User.find_by(
      matricula: aluno_data['matricula']
    )

    unless user
      curso = aluno_data['curso'] || ''
      departamento = curso.split('/').last

      user = User.create!(
        matricula: aluno_data['matricula'],
        name: aluno_data['nome'],
        email: aluno_data['email'],
        role: 'user',
        department: departamento,
        first_access: true,
        password: SecureRandom.hex(16)
      )

      #user.send_reset_password_instructions
    end

    TurmaAluno.find_or_create_by(
      turma: turma,
      aluno_id: user.id
    )
  end

  def self.import_teacher(docente_data,turma)
    user = User.find_by(
      email: docente_data['email']
    )

    unless user
      department = docente_data['departamento']

      user = User.create!(
        matricula: docente_data['usuario'],
        name: docente_data['nome'],
        email: docente_data['email'],
        role: 'admin',
        department: turma.disciplina.department,
        first_access: true,
        password: SecureRandom.hex(16)
      )

      #user.send_reset_password_instructions
    end

  end
end