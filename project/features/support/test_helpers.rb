module TestHelpers
  def criar_admin
    sufixo = SecureRandom.hex(4)
    User.create!(
      name: "Admin Teste #{sufixo}",
      email: "admin#{sufixo}@teste.com",
      registration: "ADM#{sufixo}",
      role: :admin,
      password: "Senha@123"
    )
  end

  def fazer_login_como(user, password: "Senha@123")
    visit login_path
    fill_in "Email ou matricula", with: user.email
    fill_in "Senha", with: password
    click_button "Entrar"
  end

  def criar_template_com_questao(admin, titulo: "Template #{SecureRandom.hex(4)}", target_role: "discente", enunciado: "Qual é a resposta correta?")
    template = admin.templates.create!(title: titulo, target_role: target_role)
    template.questaos.create!(enunciado: enunciado, tipo: "text")
    template
  end

  def criar_turma
    department = Department.find_or_create_by!(code: "DEPT001") { |d| d.name = "Departamento de Teste" }
    sufixo = SecureRandom.hex(4)
    CourseClass.create!(
      code: "CIC#{sufixo}",
      class_code: "T#{sufixo}",
      name: "Disciplina Teste #{sufixo}",
      semester: "2026.1",
      time: "10:00",
      department: department
    )
  end
end

World(TestHelpers)
