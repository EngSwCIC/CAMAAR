require "rails_helper"

RSpec.describe "Templates", type: :request do
  let(:current_administrador) { double("PerfilAdm", id: 1) }
  let(:current_user) do
    double(
      "Usuario",
      administrador?: true,
      perfil_adm: current_administrador,
      nome: "Administrador",
      matricula: "ADM001",
      email: "administrador@example.com"
    )
  end
  let(:template) do
    Template.new(
      id: 1,
      titulo: "Avaliação",
      descricao: "Descrição do template",
      adm_id: 1
    )
  end

  before do
    allow(template).to receive(:persisted?).and_return(true)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user)
      .and_return(current_user)

    allow_any_instance_of(ApplicationController)
      .to receive(:current_administrador)
      .and_return(current_administrador)

    allow_any_instance_of(ApplicationController)
      .to receive(:authorize!)
      .and_return(true)

    allow(template).to receive(:questoes).and_return([])
  end

  describe "GET /templates" do
    it "returns a successful response" do
      policy_scope = double("TemplatePolicyScope")
      included_scope = double("IncludedTemplates")
      ordered_scope = double("OrderedTemplates")

      allow_any_instance_of(ApplicationController)
        .to receive(:policy_scope)
        .with(Template)
        .and_return(policy_scope)

      allow(policy_scope)
        .to receive(:includes)
        .with(adm: :usuario)
        .and_return(included_scope)
      allow(included_scope).to receive(:recentes).and_return(ordered_scope)
      allow(ordered_scope)
        .to receive(:criados_por)
        .with(current_administrador)
        .and_return([])
      allow(ordered_scope)
        .to receive(:criados_por_outros)
        .with(current_administrador)
        .and_return([])

      get templates_path

      expect(response).to have_http_status(:ok)
      expect(
        Nokogiri::HTML(response.body)
          .at_xpath("//a[normalize-space()='Voltar aos templates']")
      ).to be_nil

      pagina = Nokogiri::HTML(response.body)
      expect(pagina.at_css("#meus-templates a.template-form__floating-action[href='#{new_template_path}']")).to be_present
      expect(pagina.at_css("#meus-templates a.template-form__add-template-button")).to be_nil
    end

    it "renderiza a lixeira que envia DELETE para um template próprio" do
      policy_scope = double("TemplatePolicyScope")
      included_scope = double("IncludedTemplates")
      ordered_scope = double("OrderedTemplates")

      allow_any_instance_of(ApplicationController)
        .to receive(:policy_scope)
        .with(Template)
        .and_return(policy_scope)
      allow(policy_scope)
        .to receive(:includes)
        .with(adm: :usuario)
        .and_return(included_scope)
      allow(included_scope).to receive(:recentes).and_return(ordered_scope)
      allow(ordered_scope)
        .to receive(:criados_por)
        .with(current_administrador)
        .and_return([ template ])
      allow(ordered_scope)
        .to receive(:criados_por_outros)
        .with(current_administrador)
        .and_return([])
      allow(template).to receive(:formularios).and_return([])

      get templates_path

      pagina = Nokogiri::HTML(response.body)
      card = pagina.at_css('article[data-template-id="1"]')
      formulario = card.at_css("form[action='#{template_path(template)}']")

      expect(response).to have_http_status(:ok)
      expect(formulario["data-turbo-confirm"]).to include("Excluir o template")
      expect(formulario.at_css('input[name="_method"][value="delete"]')).to be_present
      expect(
        formulario.at_css('button[aria-label="Excluir template Avaliação"]')
      ).to be_present
      expect(formulario.at_css('img[src*="icons/trash"]')).to be_present
      expect(pagina.at_css("#meus-templates a.template-form__add-template-button[href='#{new_template_path}']")).to be_present
      expect(pagina.at_css("#meus-templates a.template-form__floating-action")).to be_nil
    end
  end

  describe "GET /templates/new" do
    it "returns a successful response" do
      new_template = Template.new(adm_id: 1)

      allow(new_template).to receive(:questoes).and_return([])
      allow(Template)
        .to receive(:new)
        .with(adm: current_administrador)
        .and_return(new_template)

      get new_template_path

      expect(response).to have_http_status(:ok)
      expect(
        Nokogiri::HTML(response.body)
          .at_xpath("//a[normalize-space()='Voltar aos templates']")["href"]
      ).to eq(templates_path)

      labels = Nokogiri::HTML(response.body)
        .css(".template-form__metadata label")
        .map { |label| label.text.strip }
      expect(labels).to include("Título", "Descrição")
    end

    it "prepara uma questão inicial sem tipo e sem opções" do
      new_template = Template.new(adm_id: 1)

      allow(new_template).to receive(:questoes).and_return([])
      allow(Template)
        .to receive(:new)
        .with(adm: current_administrador)
        .and_return(new_template)

      get new_template_path

      questao = new_template.utilizacoes_questoes.first.questao
      expect(questao.tipo).to be_nil
      expect(questao.opcoes).to be_empty
    end

    it "não renderiza campos de exclusão persistida na criação" do
      new_template = Template.new(adm_id: 1)

      allow(new_template).to receive(:questoes).and_return([])
      allow(Template)
        .to receive(:new)
        .with(adm: current_administrador)
        .and_return(new_template)

      get new_template_path

      expect(response.body).to include("template-form#destroyQuestion")
      expect(response.body).to include("template-form#destroyOption")
      expect(response.body).not_to include(
        "template[utilizacoes_questoes_attributes][0][id]"
      )
      expect(response.body).not_to include(
        "template[utilizacoes_questoes_attributes][0][_destroy]"
      )
      expect(response.body).not_to include(
        "template[utilizacoes_questoes_attributes][NEW_QUESTION][id]"
      )
      expect(response.body).not_to include(
        "template[utilizacoes_questoes_attributes][NEW_QUESTION][_destroy]"
      )
    end
  end

  describe "GET /templates/:id" do
    it "returns a successful response" do
      allow(Template).to receive(:find).with("1").and_return(template)

      get template_path(template)

      expect(response).to have_http_status(:ok)
      pagina = Nokogiri::HTML(response.body)
      links_de_acao = pagina.css(".template-form__actions a")

      expect(links_de_acao.map { |link| link.text.strip }).to eq(
        [ "Voltar aos templates", "Editar" ]
      )
      expect(links_de_acao.first["href"]).to eq(templates_path)
    end

    it "renderiza no cabeçalho o botão para usar o template em um formulário" do
      allow(Template).to receive(:find).with("1").and_return(template)

      get template_path(template)

      pagina = Nokogiri::HTML(response.body)
      botao = pagina.at_css(
        ".app-page__header--split .app-button--accent"
      )

      expect(botao.text.strip).to eq("Usar em Formulário")
      expect(botao["href"]).to eq(
        new_formulario_path(template_id: template.id)
      )
    end
  end

  describe "POST /templates" do
    it "creates a template and redirects to the created record" do
      new_template = Template.new(
        id: 1,
        titulo: "Avaliação",
        descricao: "Descrição",
        adm_id: 1
      )

      allow(new_template).to receive(:persisted?).and_return(true)
      allow(new_template).to receive(:adm=)
      allow(new_template).to receive(:save).and_return(true)
      allow(Template)
        .to receive(:new)
        .and_return(new_template)

      post templates_path, params: {
        template: {
          titulo: "Avaliação",
          descricao: "Descrição"
        }
      }

      expect(new_template).to have_received(:save)
      expect(response).to redirect_to(template_path(new_template))
    end

    it "persiste questões adicionadas no frontend no submit final" do
      administrador = create_admin_usuario.perfil_adm

      allow_any_instance_of(ApplicationController)
        .to receive(:current_administrador)
        .and_return(administrador)

      expect do
        post templates_path, params: {
          template: {
            titulo: "Avaliação com campos dinâmicos",
            descricao: "Descrição",
            utilizacoes_questoes_attributes: {
              "0" => {
                numero: "1",
                questao_attributes: {
                  enunciado: "Descreva os pontos positivos",
                  tipo: "discursiva"
                }
              },
              "1" => {
                numero: "2",
                questao_attributes: {
                  enunciado: "Como você avalia a disciplina?",
                  tipo: "objetiva",
                  opcoes_attributes: {
                    "0" => {
                      numero: "1",
                      texto: "Boa"
                    },
                    "1" => {
                      numero: "2",
                      texto: "Excelente"
                    }
                  }
                }
              }
            }
          }
        }
      end.to change(Template, :count).by(1)
        .and change(UtilizacaoQuestao, :count).by(2)
        .and change(Opcao, :count).by(2)

      expect(response).to redirect_to(template_path(Template.last))
    end
  end

  describe "GET /templates/:id/edit" do
    it "returns a successful response for the owner" do
      allow(Template).to receive(:find).with("1").and_return(template)

      get edit_template_path(template)

      expect(response).to have_http_status(:ok)
      expect(
        Nokogiri::HTML(response.body)
          .at_xpath("//a[normalize-space()='Voltar aos templates']")["href"]
      ).to eq(templates_path)
    end

    it "renderiza botões para remover questões e opções via update do template" do
      template_com_questao_objetiva = create_template_with_questoes(
        titulo: "Avaliação objetiva",
        questoes: [
          {
            enunciado: "Como você avalia a disciplina?",
            tipo: :objetiva,
            opcoes: %w[Ruim Regular Bom]
          }
        ]
      )

      allow(Template)
        .to receive(:find)
        .with(template_com_questao_objetiva.id.to_s)
        .and_return(template_com_questao_objetiva)

      get edit_template_path(template_com_questao_objetiva)

      expect(response.body).to include("/assets/icons/trash-")
      expect(response.body).to include(
        "template[utilizacoes_questoes_attributes][0][id]"
      )
      expect(response.body).to include(
        "template[utilizacoes_questoes_attributes][0][_destroy]"
      )
      expect(response.body).to include(
        "template[utilizacoes_questoes_attributes][0]" \
          "[questao_attributes][opcoes_attributes][0][id]"
      )
      expect(response.body).to include(
        "template[utilizacoes_questoes_attributes][0]" \
          "[questao_attributes][opcoes_attributes][0][_destroy]"
      )
      expect(response.body).to include("template-form#destroyQuestion")
      expect(response.body).to include("template-form#destroyOption")
      expect(response.body).to include("template-form#ensureObjectiveOptions")

      pagina = Nokogiri::HTML(response.body)
      formulario_template = pagina.at_css("form.template-form")
      expect(formulario_template.css("input[type='checkbox']")).to be_empty
      expect(formulario_template.text).not_to include("Remover")

      placeholders = pagina
        .css(
          '[data-template-form-question-index="0"] ' \
            "[data-template-form-option-text]"
        )
        .map { |campo| campo["placeholder"] }

      expect(placeholders).to eq([ "Opção 1", "Opção 2", "Opção 3" ])

      dropdown = pagina.at_css(
        '[data-template-form-question-index="0"] [data-controller="dropdown"]'
      )
      select_nativo = dropdown.at_css("select[data-dropdown-target='native']")
      gatilho = dropdown.at_css("button[data-dropdown-target='trigger']")
      menu = dropdown.at_css("[role='listbox'][data-dropdown-target='menu']")

      expect(select_nativo.at_css("option[selected]")["value"]).to eq("objetiva")
      expect(gatilho["aria-haspopup"]).to eq("listbox")
      expect(gatilho["aria-expanded"]).to eq("false")
      expect(menu["hidden"]).not_to be_nil
      expect(
        menu.css("[role='option']").map { |opcao| opcao.text.strip }
      ).to eq([ "Tipo de questão", "Discursiva", "Objetiva" ])
    end

    it "renderiza botões frontend para adicionar questão e opção" do
      allow(Template).to receive(:find).with("1").and_return(template)

      get edit_template_path(template)

      expect(response.body).to include("data-controller=\"template-form\"")
      expect(response.body).to include("template-form#addQuestion")
      expect(response.body).to include("template-form#addOption")
      expect(response.body).to include("template-form#moveQuestionUp")
      expect(response.body).to include("template-form#moveQuestionDown")
      expect(response.body).to include("template-form#moveOptionUp")
      expect(response.body).to include("template-form#moveOptionDown")
      expect(response.body).to include("data-template-form-question-number")
      expect(response.body).to include("data-template-form-option-number")
      expect(response.body).not_to include("type=\"number\"")
      expect(response.body).not_to include("name=\"adicionar_questao\"")
      expect(response.body).not_to include("name=\"adicionar_opcao\"")
      expect(response.body).to include("/assets/icons/plus-")
      expect(response.body).to include("/assets/icons/arrow-up-")
      expect(response.body).to include("/assets/icons/arrow-down-")
      expect(response.body).not_to include("<span>Adicionar")
      expect(response.body).not_to include("<span>Mover")
    end
  end

  describe "PATCH /templates/:id" do
    it "updates the template and redirects to the index" do
      allow(Template).to receive(:find).with("1").and_return(template)
      allow(template).to receive(:update).and_return(true)

      patch template_path(template), params: {
        template: { titulo: "Novo título" }
      }

      expect(template).to have_received(:update)
        .with(ActionController::Parameters.new(titulo: "Novo título").permit!)
      expect(response).to redirect_to(template_path(template))
    end

    it "persiste opções adicionadas no frontend no submit final" do
      template_com_questao_objetiva = create_template_with_questoes(
        titulo: "Avaliação objetiva",
        questoes: [
          {
            enunciado: "Como você avalia a disciplina?",
            tipo: :objetiva,
            opcoes: %w[Ruim Regular Bom]
          }
        ]
      )
      utilizacao = template_com_questao_objetiva.utilizacoes_questoes.first
      questao = utilizacao.questao

      expect do
        patch template_path(template_com_questao_objetiva), params: {
          template: {
            titulo: template_com_questao_objetiva.titulo,
            descricao: template_com_questao_objetiva.descricao,
            utilizacoes_questoes_attributes: {
              "0" => {
                id: utilizacao.id,
                numero: utilizacao.numero,
                questao_attributes: {
                  id: questao.id,
                  enunciado: questao.enunciado,
                  tipo: "objetiva",
                  opcoes_attributes: questao.opcoes.each_with_index.to_h do |opcao, index|
                    [
                      index.to_s,
                      {
                        id: opcao.id,
                        numero: opcao.numero,
                        texto: opcao.texto
                      }
                    ]
                  end.merge(
                    "3" => {
                      numero: "4",
                      texto: "Excelente"
                    }
                  )
                }
              }
            }
          }
        }
      end.to change(Opcao, :count).by(1)

      expect(response).to redirect_to(template_path(template_com_questao_objetiva))
      expect(questao.opcoes.reload.pluck(:texto)).to include("Excelente")
    end

    it "rejeita a exclusão da última questão somente no submit do formulário" do
      template_com_uma_questao = create_template_with_questoes(
        titulo: "Avaliação discursiva",
        questoes: [
          {
            enunciado: "Descreva sua experiência",
            tipo: :discursiva
          }
        ]
      )
      utilizacao = template_com_uma_questao.utilizacoes_questoes.sole

      patch template_path(template_com_uma_questao), params: {
        template: {
          titulo: template_com_uma_questao.titulo,
          utilizacoes_questoes_attributes: {
            "0" => {
              id: utilizacao.id,
              _destroy: "1"
            }
          }
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("deve conter ao menos uma questão")
      expect(UtilizacaoQuestao.exists?(utilizacao.id)).to be(true)

      questao_removida = Nokogiri::HTML(response.body)
        .at_css("[data-template-form-question][hidden]")
      expect(questao_removida).to be_present
      expect(
        questao_removida.at_css("[data-template-form-question-destroy]")["value"]
      ).to eq("1")
    end

    it "rejeita deixar uma questão objetiva com apenas uma opção no submit" do
      template_objetivo = create_template_with_questoes(
        titulo: "Avaliação objetiva mínima",
        questoes: [
          {
            enunciado: "Como você avalia a disciplina?",
            tipo: :objetiva,
            opcoes: %w[Ruim Boa]
          }
        ]
      )
      utilizacao = template_objetivo.utilizacoes_questoes.sole
      questao = utilizacao.questao
      opcao_removida = questao.opcoes.first

      patch template_path(template_objetivo), params: {
        template: {
          titulo: template_objetivo.titulo,
          utilizacoes_questoes_attributes: {
            "0" => {
              id: utilizacao.id,
              numero: utilizacao.numero,
              questao_attributes: {
                id: questao.id,
                enunciado: questao.enunciado,
                tipo: "objetiva",
                opcoes_attributes: {
                  "0" => {
                    id: opcao_removida.id,
                    _destroy: "1"
                  }
                }
              }
            }
          }
        }
      }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include(
        "Opções devem ter pelo menos duas alternativas para questão objetiva"
      )
      expect(response.body).not_to include("Utilizacoes questoes questao opcoes")
      expect(Opcao.exists?(opcao_removida.id)).to be(true)

      pagina = Nokogiri::HTML(response.body)
      dialogo = pagina.at_css(
        "dialog.app-dialog.app-dialog--error[data-error-dialog-target='dialog']"
      )
      expect(dialogo).to be_present
      expect(dialogo.at_css("h2").text.strip).to eq("Não foi possível salvar")
      expect(dialogo.text).to include(
        "Opções devem ter pelo menos duas alternativas para questão objetiva"
      )
      expect(
        dialogo.at_css("button[aria-label='Fechar mensagem de erro']")
      ).to be_present

      opcao_oculta = pagina.at_css("[data-template-form-option][hidden]")
      expect(opcao_oculta).to be_present
      expect(
        opcao_oculta.at_css("[data-template-form-option-destroy]")["value"]
      ).to eq("1")
    end
  end

  describe "DELETE /templates/:id" do
    it "destroys the template and redirects to the index" do
      allow(Template).to receive(:find).with("1").and_return(template)
      allow(template).to receive(:destroy)

      delete template_path(template)

      expect(template).to have_received(:destroy)
      expect(response).to redirect_to(templates_path)
    end
  end
end
