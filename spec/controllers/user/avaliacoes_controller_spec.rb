require 'rails_helper'

RSpec.describe User::AvaliacoesController, type: :controller do
  let(:aluno) { create(:pessoa, email: "aluno@example.com") }
  let(:turmas) { create_list(:turma, 2) }
  before do
    aluno.turmas << turmas
    session[:email] = aluno.email # 'loga' forçado o aluno teste
  end

  # Teste para página inicial de avaliacoes
  describe "GET #index" do
    # Usando factories, cria alunos, turmas e formulários para o teste
    let!(:formularios_validos) do
      turmas.map { |turma| create(:formulario, turma: turma, nome: "Formulário Válido") }
    end
    let!(:formularios_invalidos) do
      create_list(:formulario, 1, nome: "")
    end


    # Checar se email da sessão está correto
    it "finds aluno by session email" do
      expect(Pessoa).to receive(:find_by).with(email: aluno.email).and_call_original
      get :index
    end

    # Checar se recebeu id correto da turma
    it "gets turma ids from aluno" do
      get :index
      expect(assigns(:formularios).map(&:turma_id).uniq.sort).to eq(turmas.map(&:id).sort)
    end

    # Checar se formularios retornados realmente não foram recebidos, criando um formulário respondido 
    it "gets formularios not yet responded to by aluno" do
      responded_form = create(:formulario)
      aluno.formulario_respondidos.create!(formulario: responded_form)

      get :index
      expect(assigns(:formularios)).not_to include(responded_form)
    end

    # Checa se está retornando os formulários válidos
    it "returns valid formularios not yet responded to" do
      get :index
      expect(assigns(:formularios)).to match_array(formularios_validos)
    end

    # e acusando os formulários inválidos
    it "sets flash alert if there are invalid formularios" do
      get :index
      expect(flash.now[:alert]).to eq("Um ou mais formulários estão incompatíveis e não podem ser visualizados")
    end

    # Checa se não acusa inválidos caso não existam
    context "when no invalid forms exist" do
      before do
        # Para esse caso, torna o formulário inválido válido
        Formulario.where(nome: "").update_all(nome: "Valid")
      end

      it "does not set flash alert" do
        get :index
        expect(flash.now[:alert]).to be_nil
      end
    end

    # Checa se chama a view corretamente
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end

  # Testa página de resposta do formulário
  describe "GET #responder" do
    # Usando factories, cria alunos, turmas e formulários para o teste
    let(:formulario) { create(:formulario) }
    let(:ligacao_pergunta) { formulario.ligacao_pergunta }
    let!(:perguntas) { create_list(:pergunta, 3, ligacao_pergunta: ligacao_pergunta) }

    it "loads the formulario and perguntas" do
      get :responder, params: { id: formulario.id }

      expect(assigns(:formulario)).to eq(formulario)
      expect(assigns(:perguntas)).to match_array(perguntas)
    end

    it "renders the responder_formulario template" do
      get :responder, params: { id: formulario.id }
      expect(response).to render_template("responder_formulario")
      expect(response).to have_http_status(:ok)
    end
  end

  # Testa método de enviar respostas
  describe "POST #enviar_respostas" do
    let(:formulario) { create(:formulario) }
    let(:ligacao_pergunta) { formulario.ligacao_pergunta }
    let!(:perguntas) { create_list(:pergunta, 3, ligacao_pergunta: ligacao_pergunta) }
    
    let(:valid_respostas) do
      perguntas.each_with_object({}) do |pergunta, hash|
        hash[pergunta.id.to_s] = "Resposta para pergunta #{pergunta.id}"
      end
    end

    context "when all perguntas are answered" do
      it "creates Resposta records for each pergunta" do
        expect {
          post :enviar_respostas, params: { id: formulario.id, respostas: valid_respostas }
        }.to change(Resposta, :count).by(perguntas.size)
      end

      it "creates a FormularioRespondido record" do
        expect {
          post :enviar_respostas, params: { id: formulario.id, respostas: valid_respostas }
        }.to change(FormularioRespondido, :count).by(1)
      end

      it "redirects to user_avaliacoes_path with success notice" do
        post :enviar_respostas, params: { id: formulario.id, respostas: valid_respostas }
        expect(response).to redirect_to(user_avaliacoes_path)
        expect(flash[:notice]).to eq("Resposta enviada com sucesso")
      end
    end

    context "when one or more perguntas are missing respostas" do
      let(:invalid_respostas) do
        # Retira alguma resposta pra simular incompleto
        hash = valid_respostas.dup
        hash.delete(perguntas.first.id.to_s)
        hash
      end

      it "does NOT create any Resposta records" do
        expect {
          post :enviar_respostas, params: { id: formulario.id, respostas: invalid_respostas }
        }.not_to change(Resposta, :count)
      end

      it "does NOT create FormularioRespondido record" do
        expect {
          post :enviar_respostas, params: { id: formulario.id, respostas: invalid_respostas }
        }.not_to change(FormularioRespondido, :count)
      end

      it "sets flash.now[:alert]" do
        post :enviar_respostas, params: { id: formulario.id, respostas: invalid_respostas }
        expect(flash.now[:alert]).to eq("Todos os campos precisam ser preenchidos")
      end

      it "renders the responder_formulario template with status 422" do
        post :enviar_respostas, params: { id: formulario.id, respostas: invalid_respostas }
        expect(response).to render_template("responder_formulario")
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end