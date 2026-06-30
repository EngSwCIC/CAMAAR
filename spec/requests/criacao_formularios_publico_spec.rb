require "rails_helper"

RSpec.describe "Criação de formulário para discentes ou docentes", type: :request do
  let!(:departamento) { Departamento.create!(nome_departamento: "CIC") }
  let!(:usuario_admin) { criar_usuario("Administrador", "admin-formularios@example.com", :admin) }
  let!(:admin) { Admin.create!(usuario: usuario_admin, departamento: departamento) }
  let!(:criador_formulario) { CriadorFormulario.create!(usuario: usuario_admin) }
  let!(:usuario_professor) { criar_usuario("Professor", "professor-formularios@example.com", :professor) }
  let!(:professor) { Professor.create!(usuario: usuario_professor) }
  let!(:materia) do
    Materia.create!(
      codigoMateria: "CIC0001",
      nome_materia: "Engenharia de Software",
      descricao_materia: "Disciplina de teste",
      departamento: departamento
    )
  end
  let!(:turma) do
    Turma.create!(
      numero_turma: 1,
      semestre_string: "2026.1",
      materia: materia,
      professor: professor
    )
  end
  let(:template_formulario) { criar_template("Template existente") }

  def criar_usuario(nome, email, role)
    Usuario.create!(
      nome: nome,
      email: email,
      role: role,
      password: "Senha123",
      password_confirmation: "Senha123"
    )
  end

  def criar_template(nome)
    TemplateFormulario.create!(
      nome_template: nome,
      criador_formulario: criador_formulario
    )
  end

  def entrar_como(usuario)
    post login_path, params: { email: usuario.email, password: "Senha123" }
  end

  def parametros_validos(publico_alvo: "discente")
    {
      formulario: {
        nome_formulario: "Avaliação da Turma",
        template_formulario_id: template_formulario.id,
        turma_id: turma.id,
        publico_alvo: publico_alvo
      }
    }
  end

  it "redireciona visitante para o login" do
    get enviar_formularios_path

    expect(response).to redirect_to(login_path)
  end

  it "retorna 403 para usuário sem permissão administrativa" do
    entrar_como(usuario_professor)

    get enviar_formularios_path

    expect(response).to have_http_status(:forbidden)
    expect(response.body).to include(
      "Acesso negado, a criação de formulários requer privilégios de administrador"
    )
  end

  it "impede criação direta por usuário sem permissão administrativa" do
    entrar_como(usuario_professor)

    expect {
      post enviar_formularios_path, params: parametros_validos(publico_alvo: "docente")
    }.not_to change(Formulario, :count)

    expect(response).to have_http_status(:forbidden)
  end

  it "exibe mensagem controlada quando não há templates" do
    entrar_como(usuario_admin)

    get enviar_formularios_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Não existem templates disponíveis para criar formulários.")
  end

  it "cria formulário para discentes com os campos usados pela #109" do
    estudante_usuario = criar_usuario("Estudante", "estudante-formularios@example.com", :estudante)
    estudante = Estudante.create!(usuario: estudante_usuario, matricula: "231000001")
    Matricula.create!(estudante: estudante, turma: turma, trancado: false)
    entrar_como(usuario_admin)

    expect {
      post enviar_formularios_path, params: parametros_validos
    }.to change(Formulario, :count).by(1)

    formulario = Formulario.last
    expect(response).to redirect_to(enviar_formularios_path)
    expect(formulario).to have_attributes(
      nome_formulario: "Avaliação da Turma",
      template_formulario_id: template_formulario.id,
      turma_id: turma.id,
      publico_estudante: true,
      criador_formulario_id: criador_formulario.id
    )
  end

  it "cria formulário para docentes com os campos usados pela #109" do
    entrar_como(usuario_admin)

    expect {
      post enviar_formularios_path, params: parametros_validos(publico_alvo: "docente")
    }.to change(Formulario, :count).by(1)

    expect(Formulario.last).to have_attributes(
      turma_id: turma.id,
      publico_estudante: false,
      criador_formulario_id: criador_formulario.id
    )
  end

  it "não cria formulário sem nome" do
    parametros = parametros_validos(publico_alvo: "docente")
    parametros[:formulario][:nome_formulario] = ""
    entrar_como(usuario_admin)

    expect {
      post enviar_formularios_path, params: parametros
    }.not_to change(Formulario, :count)

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Nome formulario é obrigatório")
  end

  it "não cria formulário sem template" do
    parametros = parametros_validos(publico_alvo: "docente")
    parametros[:formulario][:template_formulario_id] = ""
    entrar_como(usuario_admin)

    expect {
      post enviar_formularios_path, params: parametros
    }.not_to change(Formulario, :count)

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Template formulario é obrigatório")
  end

  it "não cria formulário sem turma" do
    parametros = parametros_validos(publico_alvo: "docente")
    parametros[:formulario][:turma_id] = ""
    entrar_como(usuario_admin)

    expect {
      post enviar_formularios_path, params: parametros
    }.not_to change(Formulario, :count)

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Turma é obrigatória")
  end

  it "não cria formulário sem público-alvo" do
    parametros = parametros_validos
    parametros[:formulario].delete(:publico_alvo)
    entrar_como(usuario_admin)

    expect {
      post enviar_formularios_path, params: parametros
    }.not_to change(Formulario, :count)

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Publico estudante deve ser Discente ou Docente")
  end

  it "não cria formulário discente para turma sem matrícula ativa" do
    estudante_usuario = criar_usuario("Estudante", "trancado-formularios@example.com", :estudante)
    estudante = Estudante.create!(usuario: estudante_usuario, matricula: "231000002")
    Matricula.create!(estudante: estudante, turma: turma, trancado: true)
    entrar_como(usuario_admin)

    expect {
      post enviar_formularios_path, params: parametros_validos
    }.not_to change(Formulario, :count)

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("a turma selecionada não possui discentes matriculados")
  end

  it "não permite nome duplicado para a mesma turma e público-alvo" do
    Formulario.create!(
      nome_formulario: "Avaliação da Turma",
      template_formulario: template_formulario,
      turma: turma,
      publico_estudante: false,
      criador_formulario: criador_formulario
    )
    entrar_como(usuario_admin)

    expect {
      post enviar_formularios_path, params: parametros_validos(publico_alvo: "docente")
    }.not_to change(Formulario, :count)

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("já existe para a turma e público-alvo selecionados")
  end

  it "permite o mesmo nome para público-alvo diferente" do
    Formulario.create!(
      nome_formulario: "Avaliação da Turma",
      template_formulario: template_formulario,
      turma: turma,
      publico_estudante: true,
      criador_formulario: criador_formulario
    )
    entrar_como(usuario_admin)

    expect {
      post enviar_formularios_path, params: parametros_validos(publico_alvo: "docente")
    }.to change(Formulario, :count).by(1)
  end

  it "não aplica as validações da #113 fora do contexto específico" do
    formulario = Formulario.new(
      template_formulario: template_formulario,
      turma: turma,
      criador_formulario: criador_formulario
    )

    expect(formulario.save).to be(true)
  end

  it "trata administrador sem CriadorFormulario com erro controlado" do
    usuario_sem_criador = criar_usuario("Admin sem criador", "admin-sem-criador@example.com", :admin)
    Admin.create!(usuario: usuario_sem_criador, departamento: departamento)
    entrar_como(usuario_sem_criador)

    expect {
      post enviar_formularios_path, params: parametros_validos(publico_alvo: "docente")
    }.not_to change(Formulario, :count)

    expect(response).to have_http_status(:unprocessable_content)
    expect(response.body).to include("Administrador não possui perfil de criador de formulários.")
  end
end
