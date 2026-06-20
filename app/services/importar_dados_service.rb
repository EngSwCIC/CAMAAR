class ImportarDadosService
  def initialize(classes_data, members_data, base_url: "http://localhost:3000")
    @classes = classes_data
    @members = members_data
    @created = Hash.new(0)
    @updated = Hash.new(0)
    @email_logger = EmailLogger.new(base_url: base_url)
  end

  def call
    ActiveRecord::Base.transaction do
      @members.each { |entry| import_entry(entry) }
    end
    @email_logger.flush
    { success: true, summary: build_summary }
  rescue StandardError => e
    { success: false, errors: [ e.message ] }
  end

  private

  def import_entry(entry)
    class_info = find_class_info(entry["code"], entry["classCode"], entry["semester"])
    return unless class_info

    departamento = find_or_create_departamento(entry.dig("docente", "departamento"))
    materia      = upsert_materia(class_info, departamento)
    professor    = find_or_create_professor(entry["docente"])
    turma        = upsert_turma(class_info, materia, professor)

    Array(entry["dicente"]).each { |student| import_student(student, turma) }
  end

  def find_class_info(code, class_code, semester)
    @classes.find do |c|
      c["code"] == code &&
        c.dig("class", "classCode") == class_code &&
        c.dig("class", "semester") == semester
    end
  end

  def find_or_create_departamento(nome)
    record = Departamento.find_or_create_by!(nome_departamento: nome)
    @created[:departamentos] += 1 if record.previously_new_record?
    record
  end

  def upsert_materia(class_info, departamento)
    record = Materia.find_or_initialize_by(codigoMateria: class_info["code"])
    record.departamento = departamento if record.new_record?
    record.nome_materia = class_info["name"]
    record.save!
    track(record, :materias)
    record
  end

  def find_or_create_professor(docente_data)
    usuario = upsert_usuario(
      nome: docente_data["nome"],
      email: docente_data["email"],
      matricula: docente_data["usuario"],
      role: :professor
    )
    record = Professor.find_or_create_by!(usuario: usuario)
    @created[:professores] += 1 if record.previously_new_record?
    record
  end

  def upsert_turma(class_info, materia, professor)
    numero = class_numero(class_info.dig("class", "classCode"))
    record = Turma.find_or_initialize_by(
      materia: materia,
      numero_turma: numero,
      semestre_string: class_info.dig("class", "semester")
    )
    record.professor = professor
    record.save!
    track(record, :turmas)
    record
  end

  def import_student(student_data, turma)
    usuario = upsert_usuario(
      nome: student_data["nome"],
      email: student_data["email"],
      matricula: student_data["matricula"],
      role: :estudante
    )
    estudante = Estudante.find_or_create_by!(usuario: usuario) do |e|
      e.matricula = student_data["matricula"]
    end
    @created[:estudantes] += 1 if estudante.previously_new_record?

    matricula = Matricula.find_or_create_by!(estudante: estudante, turma: turma)
    @created[:matriculas] += 1 if matricula.previously_new_record?
  end


  # Atualiza nome para usuários existentes. Role e password nunca reescritos.
  # Novos usuários ou uusuários q n unca definiram senha recebem token de convite.
  # Login tá bloqueado até que alguém defina a própria senha pelo link de convite
  def upsert_usuario(nome:, email:, matricula:, role:)
    record = Usuario.find_or_initialize_by(email: email.to_s.downcase.strip)

    if record.new_record?
      record.matricula = matricula
      record.role      = role
    end

    record.nome = nome

    # Capture invite eligibility before save (new_record? changes after save!)
    needs_invite = record.new_record? || record.password_digest.nil?

    record.save!

    # generate_token_for requires a persisted record (uses ID + password_digest)
    if needs_invite
      token = record.generate_token_for(:password_reset)
      @email_logger.log_convite_acesso(nome: record.nome, email: record.email, token: token)
    end

    track(record, :usuarios)
    record
  end

  # "TA" → 1, "TB" → 2, etc. Ultimo caracter alfabético mapeado para ordinal.
  def class_numero(class_code)
    letter = class_code.to_s[-1] || "A"
    (letter.upcase.ord - "A".ord + 1).clamp(1, 26)
  end

  def track(record, key)
    if record.previously_new_record?
      @created[key] += 1
    elsif record.saved_changes?
      @updated[key] += 1
    end
  end

  def build_summary
    created_parts = @created.filter_map { |k, v| "#{v} #{k}" if v > 0 }
    updated_parts = @updated.filter_map { |k, v| "#{v} #{k}" if v > 0 }
    parts = []
    parts << "#{created_parts.join(', ')} criados"   if created_parts.any?
    parts << "#{updated_parts.join(', ')} atualizados" if updated_parts.any?
    parts.any? ? parts.join("; ") + "." : "Nenhuma alteração."
  end
end
