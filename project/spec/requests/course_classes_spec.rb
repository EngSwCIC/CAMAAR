require "rails_helper"

RSpec.describe "CourseClasses", type: :request do
  describe "GET /course_classes" do
    it "lista turmas do semestre mais recente do departamento do admin" do
      department = create(:department)
      admin = create(:user, :admin, department: department)
      turma_do_dept = create(:course_class, department: department, semester: "2026.1")
      outro_dept = create(:department)
      create(:course_class, department: outro_dept, semester: "2026.1")

      login_as(admin)
      get course_classes_path

      expect(response).to have_http_status(:success)
      expect(response.body).to include(turma_do_dept.name)
    end

    it "redireciona usuário não-admin para a tela de login" do
      login_as(create(:user))
      get course_classes_path

      expect(response).to redirect_to(login_path)
    end
  end

  describe "GET /course_classes/:id" do
    it "exibe a turma e seus formulários quando pertence ao departamento do admin" do
      department = create(:department)
      admin = create(:user, :admin, department: department)
      turma = create(:course_class, department: department)
      formulario = create(:formulario, course_class: turma, admin: admin)

      login_as(admin)
      get course_class_path(turma)

      expect(response).to have_http_status(:success)
      expect(response.body).to include(formulario.title)
    end

    it "redireciona quando a turma pertence a outro departamento" do
      department = create(:department)
      admin = create(:user, :admin, department: department)
      outro_dept = create(:department)
      turma_outro_dept = create(:course_class, department: outro_dept)

      login_as(admin)
      get course_class_path(turma_outro_dept)

      expect(response).to redirect_to(course_classes_path)
      follow_redirect!
      expect(response.body).to include("Acesso negado")
    end
  end
end
