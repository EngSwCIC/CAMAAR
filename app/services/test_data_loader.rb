class TestDataLoader
  def self.call
    ActiveRecord::Base.transaction do
      destroy_existing_records
      admin = ensure_admin_exists
      dcc = create_dcc_department

      load_disciplines_and_classes(dcc)
      load_class_members(dcc)
    end
  end

  private

  def self.destroy_existing_records
    RespostaItem.destroy_all
    Resposta.destroy_all
    Formulario.destroy_all
    QuestaoTemplate.destroy_all
    Template.destroy_all
    Matricula.destroy_all
    Turma.destroy_all
    Usuario.where.not(perfil: "administrador").destroy_all
    Disciplina.destroy_all
    Curso.destroy_all
    Departamento.destroy_all
  end

  def self.ensure_admin_exists
    Usuario.find_by(perfil: "administrador") || Usuario.create!(
      nome: "Administrador CAMAAR",
      email: "admin@unb.br",
      matricula: "admin_matricula",
      perfil: "administrador",
      ativo: true,
      password: "admin"
    )
  end

  def self.create_dcc_department
    Departamento.find_or_create_by!(nome: "DEPTO CIÊNCIAS DA COMPUTAÇÃO")
  end

  def self.load_disciplines_and_classes(dcc)
    classes_file = Rails.root.join("classes.json")
    return unless File.exist?(classes_file)

    JSON.parse(File.read(classes_file)).each do |c_item|
      process_discipline_and_class(c_item, dcc)
    end
  end

  def self.process_discipline_and_class(c_item, dcc)
    discipline = Disciplina.find_or_create_by!(
      codigo: c_item["code"],
      nome: c_item["name"]
    )

    Turma.find_or_create_by!(
      codigo_turma: "#{c_item["class"]["classCode"]}-#{c_item["code"]}",
      semestre: c_item["class"]["semester"],
      disciplina: discipline,
      departamento: dcc
    )
  end

  def self.load_class_members(dcc)
    members_file = Rails.root.join("class_members.json")
    return unless File.exist?(members_file)

    members_data = JSON.parse(File.read(members_file))
    members_data.each do |m_item|
      process_class_member(m_item, dcc)
    end
  end

  def self.process_class_member(m_item, dcc)
    discipline = Disciplina.find_by(codigo: m_item["code"])
    return unless discipline

    turma = find_turma(m_item, discipline)
    return unless turma

    create_or_update_docente(m_item["docente"], turma, dcc) if m_item["docente"].present?
    create_discentes_and_matriculas(m_item["dicente"], turma, dcc) if m_item["dicente"].present?
  end

  def self.find_turma(m_item, discipline)
    Turma.find_by(
      codigo_turma: "#{m_item["classCode"]}-#{m_item["code"]}",
      semestre: m_item["semester"],
      disciplina: discipline
    )
  end

  def self.create_or_update_docente(doc_data, turma, dcc)
    doc_user = Usuario.find_by(email: doc_data["email"])
    unless doc_user
      doc_user = Usuario.create!(
        nome: doc_data["nome"],
        email: doc_data["email"],
        matricula: doc_data["usuario"],
        perfil: "docente",
        ativo: true,
        departamento: dcc,
        password: "senha123"
      )
    end
    turma.update!(docente: doc_user)
  end

  def self.create_discentes_and_matriculas(dicentes_data, turma, dcc)
    dicentes_data.each do |disc_data|
      process_discente_data(disc_data, turma, dcc)
    end
  end

  def self.process_discente_data(disc_data, turma, dcc)
    curso = Curso.find_or_create_by!(nome: disc_data["curso"]) if disc_data["curso"].present?

    disc_user = Usuario.find_or_create_by!(email: disc_data["email"]) do |u|
      u.nome = disc_data["nome"]
      u.matricula = disc_data["matricula"]
      u.perfil = "discente"
      u.ativo = true
      u.curso = curso
      u.departamento = dcc
      u.password = disc_data["matricula"] || "senha123"
    end

    Matricula.find_or_create_by!(
      usuario: disc_user,
      turma: turma,
      papel_na_turma: "aluno"
    )
  end
end
