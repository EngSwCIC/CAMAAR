# This file is used to seed the database with initial/test data.
require 'json'

ActiveRecord::Base.transaction do
  puts "Limpando o banco de dados..."
  RespostaItem.destroy_all
  Resposta.destroy_all
  Formulario.destroy_all
  QuestaoTemplate.destroy_all
  Template.destroy_all
  Matricula.destroy_all
  Turma.destroy_all
  Usuario.destroy_all
  Disciplina.destroy_all
  Curso.destroy_all
  Departamento.destroy_all

  puts "Criando administrador..."
  # 1. Create Default Admin
  admin = Usuario.new(
    nome: "Administrador CAMAAR",
    email: "admin@unb.br",
    matricula: "admin_matricula",
    perfil: "administrador",
    ativo: true
  )
  admin.password = "admin"
  admin.save!

  # Create default DCC Department
  dcc = Departamento.find_or_create_by!(nome: "DEPTO CIÊNCIAS DA COMPUTAÇÃO")

  # 2. Parse classes.json to create disciplines and empty classes
  classes_file = Rails.root.join("classes.json")
  if File.exist?(classes_file)
    puts "Carregando turmas de classes.json..."
    classes_data = JSON.parse(File.read(classes_file))
    classes_data.each do |c_item|
      discipline = Disciplina.find_or_create_by!(
        codigo: c_item["code"],
        nome: c_item["name"]
      )

      # Use unique class code suffixing the discipline code to respect unique index on (codigo_turma, semestre)
      Turma.find_or_create_by!(
        codigo_turma: "#{c_item["class"]["classCode"]}-#{c_item["code"]}",
        semestre: c_item["class"]["semester"],
        disciplina: discipline,
        departamento: dcc
      )
    end
  end

  # 3. Parse class_members.json to load students, teachers and enrollments
  members_file = Rails.root.join("class_members.json")
  if File.exist?(members_file)
    puts "Carregando docentes, discentes e matrículas de class_members.json..."
    members_data = JSON.parse(File.read(members_file))
    members_data.each do |m_item|
      # Find the corresponding class
      discipline = Disciplina.find_by(codigo: m_item["code"])
      next unless discipline

      turma = Turma.find_by(
        codigo_turma: "#{m_item["classCode"]}-#{m_item["code"]}",
        semestre: m_item["semester"],
        disciplina: discipline
      )
      next unless turma

      # Create / update docente
      if m_item["docente"].present?
        doc_data = m_item["docente"]
        doc_user = Usuario.find_by(email: doc_data["email"])
        unless doc_user
          doc_user = Usuario.new(
            nome: doc_data["nome"],
            email: doc_data["email"],
            matricula: doc_data["usuario"],
            perfil: "docente",
            ativo: true,
            departamento: dcc
          )
          doc_user.password = "senha123"
          doc_user.save!
        end
        turma.update!(docente: doc_user)
      end

      # Create discentes and matriculas
      if m_item["dicente"].present?
        m_item["dicente"].each do |disc_data|
          curso = Curso.find_or_create_by!(nome: disc_data["curso"]) if disc_data["curso"].present?

          disc_user = Usuario.find_by(email: disc_data["email"])
          unless disc_user
            disc_user = Usuario.new(
              nome: disc_data["nome"],
              email: disc_data["email"],
              matricula: disc_data["matricula"],
              perfil: "discente",
              ativo: true,
              curso: curso,
              departamento: dcc
            )
            disc_user.password = disc_data["matricula"] || "senha123"
            disc_user.save!
          end

          # Create Matricula
          Matricula.find_or_create_by!(
            usuario: disc_user,
            turma: turma,
            papel_na_turma: "aluno"
          )
        end
      end
    end
  end
  puts "Semente carregada com sucesso!"
end
