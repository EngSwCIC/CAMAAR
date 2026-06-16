class UpdateDataService

  def self.update_all
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

      updated_records = 0

      updated_records += update_disciplinas_classes(classes_data)
      updated_records += update_users_members(members_data)

      if updated_records.zero?
        {
          success: true,
          updated: false,
          message: 'Não há novos dados para atualização'
        }
      else
        {
          success: true,
          updated: true,
          message: 'Dados atualizados com sucesso'
        }
      end

    rescue JSON::ParserError
      {
        success: false,
        error: 'Erro ao ler os arquivos JSON'
      }
    end
  end

  private

  def self.update_disciplinas_classes(classes_data)
    updates = 0

    classes_data.each do |class_data|

      department = class_data['code'].gsub(/[0-9]/, '').strip

      disciplina = Disciplina.find_or_initialize_by(
        codigo: class_data['code']
      )

      disciplina.assign_attributes(
        nome: class_data['name'],
        department: department
      )

      if disciplina.new_record? || disciplina.changed?
        #puts "Disciplina alterada: #{disciplina.codigo}" if disciplina.changed?
        disciplina.save!
        updates += 1
      end

      turma_info = class_data['class']

      turma = Turma.find_or_initialize_by(
        codigo: turma_info['classCode'],
        semestre: turma_info['semester'],
        disciplina: disciplina
      )

      turma.assign_attributes(
        horario: turma_info['time'],
      )

      if turma.new_record? || turma.changed?
        #puts "Turma alterada: #{turma.codigo}" if turma.changed?
        turma.save!
        updates += 1
      end
    end

    updates
  end

  def self.update_users_members(members_data)
    updates = 0

    members_data.each do |member_data|

      (member_data['dicente'] || []).each do |aluno_data|

        curso = aluno_data['curso'] || ''
        department = curso.split('/').last

        user = User.find_by(
          matricula: aluno_data['matricula']
        )

        next unless user

        user.assign_attributes(
          name: aluno_data['nome'],
          email: aluno_data['email']&.downcase,
          department: department
        )

        if user.changed?
          user.save!

          updates += 1 if user.saved_changes.present?
        end
      end

      docente = member_data['docente']
      next unless docente

      user = User.find_by(
        matricula: docente['usuario']
      )

      next unless user

      user.assign_attributes(
        name: docente['nome'],
        email: docente['email']&.downcase
      )

      if user.changed?
        user.save!
        updates += 1 if user.saved_changes.present?
      end
    end

    updates
  end
end