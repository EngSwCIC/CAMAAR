require "rails_helper"

RSpec.describe "Visualização de formulários pendentes", type: :request do
  let!(:departamento) { Departamento.create!(nome_departamento: "CIC") }
  let!(:materia) do
    Materia.create!(
      codigoMateria: "CIC0001",
      nome_materia: "Engenharia de Software",
      descricao_materia: "Disciplina de teste",
      departamento: departamento
    )
  end
  let!(:usuario_professor) { criar_usuario("Professor", "professor-pendencias@example.com", :professor) }
  let!(:professor) { Professor.create!(usuario: usuario_professor) }
  let!(:turma) do
    Turma.create!(
      numero_turma: 1,
      semestre_string: "2026.1",
      materia: materia,
      professor: professor
    )
  end
  let(:criador_formulario) { CriadorFormulario.create!(usuario: usuario_professor) }
  let(:template_formulario) { criar_template }

  def criar_usuario(nome, email, role)
    Usuario.create!(
      nome: nome,
      email: email,
      role: role,
      password: "Senha123",
      password_confirmation: "Senha123"
    )
  end

  def criar_template
    TemplateFormulario.create!(
      nome_template: "Template para testes",
      criador_formulario: criador_formulario
    )
  end

  def criar_formulario(nome:, turma:, publico_estudante:)
    Formulario.create!(
      nome_formulario: nome,
      publico_estudante: publico_estudante,
      template_formulario: template_formulario,
      turma: turma,
      criador_formulario: criador_formulario
    )
  end

  def entrar_como(usuario)
    post login_path, params: { email: usuario.email, password: "Senha123" }
  end

  it "redireciona visitantes para o login" do
    get avaliacoes_path

    expect(response).to redirect_to(login_path)
  end

  context "quando o usuário é estudante" do
    let!(:usuario_estudante) { criar_usuario("Estudante", "estudante-pendencias@example.com", :estudante) }
    let!(:estudante) { Estudante.create!(usuario: usuario_estudante, matricula: "231000001") }

    before do
      Matricula.create!(estudante: estudante, turma: turma, trancado: false)
      entrar_como(usuario_estudante)
    end

    it "exibe formulários de suas turmas destinados a estudantes" do
      criar_formulario(nome: "Avaliação da Turma", turma: turma, publico_estudante: true)
      criar_formulario(nome: "Avaliação do Professor", turma: turma, publico_estudante: false)

      get avaliacoes_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Avaliação da Turma")
      expect(response.body).not_to include("Avaliação do Professor")
      expect(response.body).to include("Engenharia de Software", "2026.1", "Professor")
    end

    it "não exibe formulários de outras turmas" do
      outra_turma = Turma.create!(
        numero_turma: 2,
        semestre_string: "2026.1",
        materia: materia,
        professor: professor
      )
      criar_formulario(nome: "Formulário de Outra Turma", turma: outra_turma, publico_estudante: true)

      get avaliacoes_path

      expect(response.body).not_to include("Formulário de Outra Turma")
    end

    it "não exibe formulários já respondidos" do
      formulario = criar_formulario(nome: "Formulário Respondido", turma: turma, publico_estudante: true)
      RespostaFormulario.create!(
        formulario: formulario,
        usuario: usuario_estudante,
        data_resposta: Time.current
      )

      get avaliacoes_path

      expect(response.body).not_to include("Formulário Respondido")
      expect(response.body).to include("Você está em dia! Sem formulários para preencher.")
    end

    it "ignora matrículas trancadas" do
      Matricula.where(estudante: estudante, turma: turma).update_all(trancado: true)
      criar_formulario(nome: "Formulário de Matrícula Trancada", turma: turma, publico_estudante: true)

      get avaliacoes_path

      expect(response.body).not_to include("Formulário de Matrícula Trancada")
    end
  end

  context "quando o usuário é professor" do
    before do
      entrar_como(usuario_professor)
    end

    it "exibe formulários docentes de suas turmas" do
      criar_formulario(nome: "Autoavaliação Docente", turma: turma, publico_estudante: false)
      criar_formulario(nome: "Avaliação dos Estudantes", turma: turma, publico_estudante: true)

      get avaliacoes_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Autoavaliação Docente")
      expect(response.body).not_to include("Avaliação dos Estudantes")
    end

    it "não exibe formulários já respondidos" do
      formulario = criar_formulario(nome: "Autoavaliação Respondida", turma: turma, publico_estudante: false)
      RespostaFormulario.create!(
        formulario: formulario,
        usuario: usuario_professor,
        data_resposta: Time.current
      )

      get avaliacoes_path

      expect(response.body).not_to include("Autoavaliação Respondida")
    end
  end

  it "exibe o estado vazio quando não há formulários pendentes" do
    usuario = criar_usuario("Sem Pendências", "sem-pendencias@example.com", :estudante)
    Estudante.create!(usuario: usuario, matricula: "231000002")
    entrar_como(usuario)

    get avaliacoes_path

    expect(response.body).to include("Você está em dia! Sem formulários para preencher.")
  end

  it "trata usuário sem perfil associado sem gerar erro" do
    usuario = criar_usuario("Sem Perfil", "sem-perfil@example.com", :estudante)
    entrar_como(usuario)

    get avaliacoes_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Você está em dia! Sem formulários para preencher.")
  end
end
