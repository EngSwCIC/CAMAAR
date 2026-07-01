require "rails_helper"

RSpec.describe "Formularios", type: :request do
  let(:departamento) { Departamento.create!(nome: "DCC #{SecureRandom.hex(2)}") }
  let(:admin) { create_admin_usuario(departamento: departamento) }
  let(:usuario) { create_usuario }
  let(:template) { create_template_with_questoes(titulo: "Avaliação Docente", adm: admin.perfil_adm) }
  let(:turma_a) { create_turma(nome_materia: "MDS", numero: 1, departamento: departamento) }
  let(:turma_b) { create_turma(nome_materia: "IHC", numero: 2, departamento: departamento) }

  def criar_formulario_params(template_id: template.id, turma_ids: [ turma_a.id, turma_b.id ], publico_alvo: "docentes")
    {
      template_id: template_id,
      turma_ids: turma_ids,
      publico_alvo: publico_alvo
    }
  end

  describe "GET /formularios" do
    it "exibe formulários do departamento e semestre atual para admin" do
      formulario_a = create_formulario(
        turma: turma_a,
        adm: admin.perfil_adm,
        template: template,
        publico_alvo: :docentes
      )
      formulario_b = create_formulario(
        turma: turma_b,
        adm: admin.perfil_adm,
        template: template,
        publico_alvo: :discentes
      )

      sign_in_as(admin)
      get formularios_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(formulario_a.template.titulo)
      expect(response.body).to include(formulario_a.turma.nome_exibicao)
      expect(response.body).to include("Docentes")
      expect(response.body).to include(formulario_b.turma.nome_exibicao)
      expect(response.body).to include("Discentes")
      expect(response.body).to include(formulario_path(formulario_a))
    end

    it "exibe mensagem quando não há formulários no semestre atual" do
      sign_in_as(admin)
      get formularios_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Nenhum formulário criado por você foi encontrado")
      expect(response.body).to include("Nenhum formulário de outros administradores encontrado")
    end

    it "não exibe formulários de outro departamento" do
      outro_departamento = Departamento.create!(nome: "DCC #{SecureRandom.hex(2)}")
      outra_turma = create_turma(nome_materia: "OUT", numero: 1, departamento: outro_departamento)
      outro_admin = create_admin_usuario(departamento: outro_departamento)
      outro_template = create_template_with_questoes(titulo: "Formulário Externo", adm: outro_admin.perfil_adm)
      create_formulario(
        turma: outra_turma,
        adm: outro_admin.perfil_adm,
        template: outro_template
      )

      formulario_local = create_formulario(
        turma: turma_a,
        adm: admin.perfil_adm,
        template: template
      )

      sign_in_as(admin)
      get formularios_path

      expect(response.body).to include(formulario_local.template.titulo)
      expect(response.body).not_to include("Formulário Externo")
    end

    it "não exibe formulários de semestres anteriores" do
      turma_passada = create_turma(
        nome_materia: "LEG",
        numero: 3,
        departamento: departamento,
        ano: Date.current.year - 1,
        semestre: :segundo
      )
      create_formulario(
        turma: turma_passada,
        adm: admin.perfil_adm,
        template: template,
        publico_alvo: :docentes
      )

      formulario_atual = create_formulario(
        turma: turma_a,
        adm: admin.perfil_adm,
        template: template
      )

      sign_in_as(admin)
      get formularios_path

      expect(response.body).to include(formulario_atual.turma.nome_exibicao)
      expect(response.body).not_to include(turma_passada.nome_exibicao)
    end

    it "lista formulário cujo template de origem foi removido" do
      formulario = create_formulario(
        turma: turma_a,
        adm: admin.perfil_adm,
        template: template
      )
      template.destroy!

      sign_in_as(admin)
      get formularios_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("Template removido")
      expect(response.body).to include(formulario.turma.nome_exibicao)
    end

    it "bloqueia usuário não administrador" do
      sign_in_as(usuario)

      get formularios_path

      expect(response).to redirect_to("/")
      expect(flash[:alert]).to eq("Você não tem permissão para realizar esta ação.")
    end
  end

  describe "GET /formularios/:id" do
    it "exibe o relatório de um formulário do departamento" do
      formulario = create_formulario(
        turma: turma_a,
        adm: admin.perfil_adm,
        template: template
      )

      sign_in_as(admin)
      get formulario_path(formulario)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(template.titulo)
      expect(response.body).to include(turma_a.nome_exibicao)
      expect(response.body).to include(exportar_csv_formulario_path(formulario))
    end

    it "impede acesso a formulário de outro departamento" do
      outro_departamento = Departamento.create!(nome: "Outro #{SecureRandom.hex(2)}")
      outra_turma = create_turma(
        nome_materia: "Externa",
        numero: 1,
        departamento: outro_departamento
      )
      formulario_externo = create_formulario(turma: outra_turma)

      sign_in_as(admin)
      get formulario_path(formulario_externo)

      expect(response).to redirect_to(formularios_path)
      expect(flash[:alert]).to eq(
        "Você não tem permissão para acessar esse formulário."
      )
    end
  end

  describe "GET /formularios/:id/exportar_csv" do
    it "exporta respostas registradas e marca questões sem resposta" do
      discente_com_texto = create_usuario(nome: "Discente Texto", matricula: "20260001")
      discente_com_opcao = create_usuario(nome: "Discente Opção", matricula: "20260002")
      participacao_texto = create_participacao(usuario: discente_com_texto, turma: turma_a, tipo_participacao: :discente)
      participacao_opcao = create_participacao(usuario: discente_com_opcao, turma: turma_a, tipo_participacao: :discente)
      discente_com_texto.update!(matricula: "20260001")
      discente_com_opcao.update!(matricula: "20260002")
      formulario = create_formulario(
        turma: turma_a,
        adm: admin.perfil_adm,
        template: template,
        publico_alvo: :discentes,
        criar_avaliacoes: true
      )
      questao_discursiva = formulario.questoes.find(&:discursiva?)
      questao_objetiva = formulario.questoes.find(&:objetiva?)
      avaliacao_texto = formulario.avaliacoes.find_by!(participacao_turma: participacao_texto)
      avaliacao_opcao = formulario.avaliacoes.find_by!(participacao_turma: participacao_opcao)

      Resposta.new(avaliacao: avaliacao_texto, questao: questao_discursiva).tap do |resposta|
        resposta.build_texto(texto: "Comentário textual")
        resposta.save!
      end
      Resposta.new(avaliacao: avaliacao_opcao, questao: questao_objetiva).tap do |resposta|
        resposta.opcoes_escolhidas.build(opcao: questao_objetiva.opcoes.first)
        resposta.save!
      end

      sign_in_as(admin)
      get exportar_csv_formulario_path(formulario)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/csv")
      expect(response.headers["Content-Disposition"]).to include("resultados_turma_#{turma_a.materia.codigo}")
      expect(response.body).to include("Aluno;Matrícula;#{questao_discursiva.enunciado};#{questao_objetiva.enunciado}")
      expect(response.body).to include("Discente Texto;20260001;Comentário textual;Sem resposta")
      expect(response.body).to include("Discente Opção;20260002;Sem resposta;#{questao_objetiva.opcoes.first.texto}")
    end

    it "impede exportar formulário de outro departamento" do
      outro_departamento = Departamento.create!(nome: "Outro #{SecureRandom.hex(2)}")
      outra_turma = create_turma(
        nome_materia: "Externa",
        numero: 1,
        departamento: outro_departamento
      )
      formulario_externo = create_formulario(turma: outra_turma)

      sign_in_as(admin)
      get exportar_csv_formulario_path(formulario_externo)

      expect(response).to redirect_to(formularios_path)
      expect(flash[:alert]).to eq(
        "Você não tem permissão para exportar os resultados desse formulário."
      )
    end
  end

  describe "GET /formularios/new" do
    it "pré-seleciona o template recebido pela URL" do
      sign_in_as(admin)

      get new_formulario_path(template_id: template.id)

      pagina = Nokogiri::HTML(response.body)
      template_selecionado = pagina.at_css("input[name='template_id'][checked]")

      expect(response).to have_http_status(:ok)
      expect(template_selecionado["value"]).to eq(template.id.to_s)
      expect(template_selecionado.ancestors("label").first.text).to include(template.titulo)
      expect(template_selecionado.ancestors(".formulario-section-box").first.text).to include("Template base")
      expect(template_selecionado.ancestors(".formulario-step--template")).not_to be_empty
      expect(template_selecionado["type"]).to eq("radio")
    end

    it "lista turmas em uma caixa única e usa matéria apenas como filtro inicial" do
      turma_a
      turma_b
      professor = create_usuario(nome: "Professora Ada", email: "ada@example.com")
      create_participacao(usuario: professor, turma: turma_a, tipo_participacao: :docente)
      sign_in_as(admin)

      get new_formulario_path(materia_id: turma_a.materia_id)

      pagina = Nokogiri::HTML(response.body)
      filtro = pagina.at_css("[data-controller='class-filter']")

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(turma_a.nome_exibicao)
      expect(response.body).to include(turma_b.nome_exibicao)
      expect(pagina.css(".formulario-class-group")).to be_empty
      expect(pagina.css(".formulario-classes__box .formulario-choice-card--class").size).to eq(2)
      expect(filtro["data-class-filter-selected-materia-ids-value"]).to eq(turma_a.materia_id.to_s)
      expect(pagina.at_css("#turma_#{turma_a.id}").ancestors("label").first["data-professor-ids"]).to include(professor.id.to_s)
      expect(response.body).to include("Professora Ada")
    end

    it "renderiza menu de filtro com seções recolhíveis e buscas específicas" do
      professor = create_usuario(nome: "Professor Alan", email: "alan@example.com")
      professor_do_departamento = create_usuario(nome: "Professor Sem Turma", email: "sem-turma@example.com")
      create_participacao(usuario: professor, turma: turma_a, tipo_participacao: :docente)
      create_perfil_docente(professor_do_departamento, departamento: departamento)
      sign_in_as(admin)

      get new_formulario_path

      pagina = Nokogiri::HTML(response.body)
      menu = pagina.at_css("#formulario-class-filter-menu")
      caixa_turmas = pagina.at_css(".formulario-classes__box")
      cabecalho_caixa = pagina.at_css(".formulario-classes__box-header")

      expect(response).to have_http_status(:ok)
      expect(pagina.at_css(".formulario-form-panel")).to be_present
      expect(pagina.css(".formulario-step__marker").map(&:text)).to eq(%w[1 2])
      expect(pagina.css(".template-form__metadata")).to be_empty
      expect(response.body).not_to include("Dados do formulário")
      expect(pagina.css(".formulario-section-box__heading label").map(&:text)).to include(
        "Template base",
        "Selecione as turmas alvo"
      )
      expect(pagina.at_css(".formulario-template-base__header .formulario-publico-segmented")).to be_present
      expect(menu.ancestors(".formulario-classes__box")).not_to be_empty
      expect(caixa_turmas.text).to include("Selecione as turmas alvo")
      expect(cabecalho_caixa.at_css(".formulario-class-filter__button")).to be_present
      expect(pagina.css(".formulario-class-filter__section summary").map(&:text)).to contain_exactly("Matéria", "Professor")
      expect(pagina.css(".formulario-class-filter__section[open]")).to be_empty
      expect(pagina.at_css("input[placeholder='Pesquisar matéria']")).to be_present
      expect(pagina.at_css("input[placeholder='Pesquisar professor']")).to be_present
      expect(pagina.at_css("[data-filter-type='materia'][role='menuitemcheckbox']")).to be_present
      expect(pagina.at_css("[data-filter-type='professor'][role='menuitemcheckbox']")).to be_present
      expect(pagina.at_css("[data-filter-type='professor'][data-filter-value='#{professor.id}']")).to be_present
      expect(pagina.at_css("[data-filter-type='professor'][data-filter-value='#{professor_do_departamento.id}']")).to be_present
    end

    it "renderiza a escolha de público-alvo como controle segmentado" do
      sign_in_as(admin)

      get new_formulario_path

      pagina = Nokogiri::HTML(response.body)

      expect(response).to have_http_status(:ok)
      expect(pagina.css(".formulario-publico-field")).to be_empty
      expect(pagina.at_css(".formulario-template-base__header .formulario-publico-segmented")).to be_present
      expect(pagina.css("select[name='publico_alvo']")).to be_empty
      valores_publico_alvo = pagina.css("input[name='publico_alvo'][type='radio']").map { |input| input["value"] }
      expect(valores_publico_alvo).to contain_exactly("docentes", "discentes")
      acoes = pagina.at_css(".app-actions.template-form__actions")

      expect(acoes).to be_present
      expect(acoes["class"]).not_to include("formulario-form-actions")
      expect(acoes.at_css("input.app-button--accent[type='submit']")).to be_present
    end
  end

  describe "POST /formularios" do
    it "cria formulários com template, turmas e público-alvo" do
      sign_in_as(admin)

      expect do
        post formularios_path, params: criar_formulario_params
      end.to change(Formulario, :count).by(2)

      expect(response).to redirect_to(formularios_path)
      follow_redirect!
      expect(response.body).to include("Formulário criado com sucesso para as turmas selecionadas")
    end

    it "retorna erro quando público-alvo não é informado" do
      sign_in_as(admin)

      expect do
        post formularios_path, params: criar_formulario_params(turma_ids: [ turma_a.id ], publico_alvo: "")
      end.not_to change(Formulario, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to include("Por favor, selecione o público-alvo do formulário")
    end

    it "bloqueia usuário não administrador" do
      sign_in_as(usuario)

      post formularios_path, params: criar_formulario_params

      expect(response).to redirect_to("/")
      expect(flash[:alert]).to eq("Você não tem permissão para realizar esta ação.")
      expect(Formulario.count).to eq(0)
    end
  end
end
