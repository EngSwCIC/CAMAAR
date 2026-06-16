# Importa turmas, disciplinas e participantes a partir dos JSONs do SIGAA
# (issues #4 "Importar dados do SIGAA" e #14 "Atualizar base de dados").
#
# Uso:
#   classes  = JSON.parse(File.read("classes.json"))
#   members  = JSON.parse(File.read("class_members.json"))
#   SigaaImporter.call(classes: classes, members: members)
#
# Idempotente: rodar novamente não duplica turmas, usuários ou matrículas.
class SigaaImporter
  def self.call(classes:, members:)
    new(classes, members).call
  end

  def initialize(classes, members)
    @classes = classes || []
    @members = members || []
    @counts  = { turmas: 0, users: 0, enrollments: 0 }
  end

  def call
    @classes.each { |c| upsert_turma(c["code"], c["name"], c.dig("class", "classCode"), c.dig("class", "semester"), c.dig("class", "time")) }

    @members.each do |m|
      turma = upsert_turma(m["code"], m["code"], m["classCode"], m["semester"], nil)

      Array(m["dicente"]).each { |d| upsert_user_and_enroll(d, turma, "discente") }

      docente = m["docente"]
      upsert_user_and_enroll(docente, turma, "docente") if docente.present?
    end

    @counts
  end

  private

  def upsert_turma(code, name, class_code, semester, time)
    turma = Turma.find_or_initialize_by(code: code, class_code: class_code, semester: semester)
    if turma.new_record?
      turma.name = name
      turma.time = time
      turma.save!
      @counts[:turmas] += 1
    elsif time.present? && turma.time.blank?
      turma.update!(time: time)
    end
    turma
  end

  def upsert_user_and_enroll(data, turma, role)
    matricula = data["matricula"].presence || data["usuario"].presence
    user = User.find_by(matricula: matricula) || User.find_by(email: data["email"])

    unless user
      # invite! cria o usuário e envia o e-mail de definição de senha (issue #5)
      user = User.invite!(
        nome: data["nome"],
        email: data["email"],
        matricula: matricula,
        perfil: role
      )
      @counts[:users] += 1
    end

    enrollment = Enrollment.find_or_initialize_by(user: user, turma: turma)
    if enrollment.new_record?
      enrollment.role = role
      enrollment.save!
      @counts[:enrollments] += 1
    end
    enrollment
  end
end
