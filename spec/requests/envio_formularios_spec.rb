require 'rails_helper'

RSpec.describe "EnvioFormularios", type: :request do
  let(:discente_user) { User.create!(email: "envio#{rand(1000)}@unb.br", password: "password123", perfil: "Discente", nome: "Aluno", matricula: "112233") }

  before do
    # Criação do ecossistema de dados para o teste
    @usuario = Usuario.create!(id: discente_user.id, login: "env#{discente_user.id}", email: discente_user.email, nome: "Aluno", perfil: 0, password: "123")
    @discente = Discente.create!(usuario_id: @usuario.id, curso: "Computação", matricula: discente_user.matricula)

    @departamento = Departamento.create!(nome: "Dep Envio Teste")
    @turma = Turma.create!(codigo: "ENV1", nome: "Turma Envio", semestre: "2023.1", departamento: @departamento)

    user_doc = User.create!(email: "doc#{rand(1000)}@unb.br", password: "password123", perfil: "Docente", nome: "Doc", matricula: "555")
    usu_doc = Usuario.create!(id: user_doc.id, login: "doc#{user_doc.id}", email: user_doc.email, nome: "Doc", perfil: 1, password: "123")
    @docente = Docente.create!(usuario_id: usu_doc.id, departamento: @departamento)

    @template = Template.create!(titulo: "Avaliação", docente: @docente)
    @q_template = QuestaoTemplate.create!(template: @template, enunciado: "Avalie o professor", tipo: 0)

    @formulario = Formulario.create!(titulo: "Formulário Final", turma: @turma, template: @template, prazo: 1.week.from_now)
    @questao = Questao.create!(formulario: @formulario, questao_template: @q_template, enunciado: "Avalie o professor", tipo: 0)

    # Autentica o utilizador
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(discente_user)
    allow_any_instance_of(ApplicationController).to receive(:discente_atual).and_return(@discente)
  end

  describe "GET /envio_formularios/new" do
    it "Cenário 1: redireciona para formulários se o formulário não existir" do
      get new_envio_formulario_path(formulario_id: 99999)
      expect(response).to redirect_to(formularios_path)
      expect(flash[:alert]).to eq("Formulário não encontrado.")
    end

    it "Cenário 2: redireciona para a resposta salva se o aluno já respondeu" do
      allow_any_instance_of(Discente).to receive(:ja_respondeu?).with(@formulario).and_return(true)

      get new_envio_formulario_path(formulario_id: @formulario.id)
      expect(response).to redirect_to(minha_resposta_formulario_path(@formulario))
      expect(flash[:notice]).to eq("Este formulário já foi respondido")
    end

    it "Cenário 3: carrega a página com as questões com sucesso" do
      get new_envio_formulario_path(formulario_id: @formulario.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /envio_formularios" do
    it "Cenário 4: bloqueia envio se o aluno já respondeu e redireciona" do
      allow_any_instance_of(Discente).to receive(:ja_respondeu?).with(@formulario).and_return(true)

      post envio_formularios_path(formulario_id: @formulario.id)
      expect(response).to redirect_to(formularios_path)
      expect(flash[:alert]).to eq("Este formulário já foi respondido")
    end

    it "Cenário 5: rejeita quando as respostas vêm vazias" do
      post envio_formularios_path(formulario_id: @formulario.id), params: { respostas: { @questao.id.to_s => "" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash.now[:alert]).to eq("Todos os campos obrigatórios devem ser preenchidos")
    end

    it "Cenário 6: rejeita quando os valores não estão entre 1 e 5" do
      # Envia o valor '8' para acionar o erro de validação
      post envio_formularios_path(formulario_id: @formulario.id), params: { respostas: { @questao.id.to_s => "8" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash.now[:alert]).to eq("Por favor, insira um valor válido entre 1 e 5")
    end

    it "Cenário 7: captura exceção do banco de dados na transação de salvamento" do
      # Simulamos uma falha do ActiveRecord na hora de guardar o EnvioFormulario
      allow_any_instance_of(EnvioFormulario).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(EnvioFormulario.new))

      post envio_formularios_path(formulario_id: @formulario.id), params: { respostas: { @questao.id.to_s => "4" } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(flash.now[:alert]).to include("Validation failed")
    end

    it "Cenário 8: salva as respostas com sucesso e redireciona" do
      post envio_formularios_path(formulario_id: @formulario.id), params: { respostas: { @questao.id.to_s => "5" } }

      expect(response).to redirect_to(formularios_path)
      expect(flash[:notice]).to eq("Avaliação enviada com sucesso")
    end
  end
end
