# frozen_string_literal: true

# Service for importing data from JSON files.
# Handles the logic for creating users and disciplines from structured data.
class ImportService
  # Imports users from a given data structure.
  #
  # ==== Attributes
  #
  # * +data+ - A Hash or Array of Hashes containing user data.
  #
  # ==== Returns
  #
  # * +Hash+ - A hash containing the result of the operation.
  #   - +:success+ (Boolean) - True if the import was successful, false otherwise.
  #   - +:imported+ (Integer) - The number of users successfully imported.
  #   - +:skipped+ (Integer) - The number of users skipped because they already existed.
  #   - +:error+ (String) - A message describing any errors that occurred.
  #
  # ==== Side Effects
  #
  # * Creates new User records in the database.
  #
  def self.import_users(data)
    imported = 0
    skipped = 0
    errors = []

    ActiveRecord::Base.transaction do
      # Processa tanto usuários do class_members.json quanto docentes
      process_data = []

      if data.is_a?(Array)
        data.each do |item|
          # Se o item tem estrutura class_members.json (com dicente/docente arrays)
          if item['dicente'].is_a?(Array) || item['docente'].is_a?(Hash)
            # Adiciona discentes
            process_data.concat(item['dicente']) if item['dicente'].is_a?(Array)

            # Adiciona docente
            process_data << item['docente'] if item['docente'].is_a?(Hash)
          else
            # Se o item é um usuário direto (formato test_users.json)
            process_data << item
          end
        end
      else
        process_data = [data]
      end

      process_data.each do |user_data|
        next if user_data['email'].blank?

        # Verifica se o usuário já existe
        existing_user = User.find_by(email: user_data['email'])
        if existing_user
          skipped += 1
          next
        end

        # Determina o role baseado na ocupação
        role = determine_role(user_data['ocupacao'] || user_data['formacao'])

        # Cria o usuário
        user = User.new(
          email: user_data['email'],
          name: user_data['nome'],
          matricula: user_data['matricula'] || user_data['usuario'],
          role: role,
          password: '123456', # Senha padrão
          password_confirmation: '123456',
          curso: user_data['curso'],
          departamento: user_data['departamento'],
          formacao: user_data['formacao']
        )

        if user.save
          imported += 1
        else
          errors << "Erro ao importar #{user_data['nome']}: #{user.errors.full_messages.join(', ')}"
        end
      end
    end

    if errors.any?
      { success: false, error: errors.join('; ') }
    else
      { success: true, imported: imported, skipped: skipped }
    end
  rescue StandardError => e
    { success: false, error: e.message }
  end

  # Imports disciplines from a given data structure.
  #
  # ==== Attributes
  #
  # * +data+ - An Array of Hashes containing discipline data.
  #
  # ==== Returns
  #
  # * +Hash+ - A hash containing the result of the operation.
  #   - +:success+ (Boolean) - True if the import was successful, false otherwise.
  #   - +:imported+ (Integer) - The number of disciplines successfully imported.
  #   - +:skipped+ (Integer) - The number of disciplines skipped because they already existed.
  #   - +:error+ (String) - A message describing any errors that occurred.
  #
  # ==== Side Effects
  #
  # * Creates new Disciplina and Curso records in the database.
  #
  def self.import_disciplines(data)
    imported = 0
    skipped = 0
    errors = []

    ActiveRecord::Base.transaction do
      Array(data).each do |discipline_data|
        code = discipline_data['code']
        name = discipline_data['name']
        next if code.blank? || name.blank?

        # Verifica se já existe um curso para essa disciplina
        curso_name = extract_course_from_code(code)
        curso = Curso.find_or_create_by(nome: curso_name)

        # Verifica se a disciplina já existe
        existing_discipline = Disciplina.find_by(codigo: code, nome: name)
        if existing_discipline
          skipped += 1
          next
        end

        # Cria a disciplina
        disciplina = Disciplina.new(
          codigo: code,
          nome: name,
          curso: curso
        )

        # Se houver informações da turma, cria também
        if discipline_data['class'].present?
          class_info = discipline_data['class']
          disciplina.codigo_turma = class_info['classCode']
          disciplina.semestre = class_info['semester']
          disciplina.horario = class_info['time']
        end

        if disciplina.save
          imported += 1
        else
          errors << "Erro ao importar #{name}: #{disciplina.errors.full_messages.join(', ')}"
        end
      end
    end

    if errors.any?
      { success: false, error: errors.join('; ') }
    else
      { success: true, imported: imported, skipped: skipped }
    end
  rescue StandardError => e
    { success: false, error: e.message }
  end

  # Determines the user role based on their occupation.
  #
  # ==== Attributes
  #
  # * +ocupacao+ - A string representing the user's occupation (e.g., 'docente', 'dicente').
  #
  # ==== Returns
  #
  # * +String+ - The corresponding role name ('professor', 'aluno', 'coordenador'). Defaults to 'aluno'.
  #
  def self.determine_role(ocupacao)
    case ocupacao&.downcase
    when 'docente'
      'professor'
    when 'dicente', 'graduando'
      'aluno'
    when 'coordenador'
      'coordenador'
    else
      'aluno' # padrão
    end
  end

  # Extracts the course name from a discipline code.
  #
  # ==== Attributes
  #
  # * +code+ - A string representing the discipline code (e.g., 'CIC0097').
  #
  # ==== Returns
  #
  # * +String+ - The name of the course associated with the code. Defaults to 'Curso Geral'.
  #
  def self.extract_course_from_code(code)
    # Extrai o curso baseado no código (ex: CIC0097 -> Ciência da Computação)
    case code&.upcase
    when /^CIC/
      'Ciência da Computação'
    when /^ENC/
      'Engenharia de Computação'
    when /^FTD/
      'Engenharia Mecatrônica'
    else
      'Curso Geral'
    end
  end
end
