require 'rails_helper'

RSpec.describe FormulariosController, type: :controller do
  include ActiveSupport::Testing::TimeHelpers
  
  let(:admin_user) { create(:user, role: :admin) }
  let(:aluno_user) { create(:user, role: :aluno) }
  let(:template) { create(:template, criado_por: admin_user) }
  let(:formulario) { create(:formulario, template: template, coordenador: admin_user) }
  let(:valid_attributes) do
    {
      data_envio: Date.current,
      data_fim: Date.current + 1.week,
      template_id: template.id,
      ativo: true
    }
  end
  let(:invalid_attributes) { { template_id: nil } }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'when user is admin' do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    # Happy Path Tests
    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end

      it 'assigns all formularios' do
        formulario
        get :index
        expect(assigns(:formularios)).to include(formulario)
      end

      it 'renders the index template' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        get :show, params: { id: formulario.to_param }
        expect(response).to be_successful
      end

      it 'assigns the requested formulario' do
        get :show, params: { id: formulario.to_param }
        expect(assigns(:formulario)).to eq(formulario)
      end

      it 'renders the show template' do
        get :show, params: { id: formulario.to_param }
        expect(response).to render_template(:show)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns a new formulario' do
        get :new
        expect(assigns(:formulario)).to be_a_new(Formulario)
      end

      it 'loads necessary data for forms' do
        template # Create the template
        create(:turma) # Create at least one turma
        create(:disciplina) # Create at least one disciplina
        get :new
        expect(assigns(:templates)).to be_present
        expect(assigns(:turmas)).to be_present
        expect(assigns(:disciplinas)).to be_present
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        get :edit, params: { id: formulario.to_param }
        expect(response).to be_successful
      end

      it 'assigns the requested formulario' do
        get :edit, params: { id: formulario.to_param }
        expect(assigns(:formulario)).to eq(formulario)
      end
    end

    describe 'POST #create' do
      context 'with valid params' do
        it 'creates a new Formulario' do
          expect {
            post :create, params: { formulario: valid_attributes }
          }.to change(Formulario, :count).by(1)
        end

        it 'sets the coordenador_id to current_user' do
          post :create, params: { formulario: valid_attributes }
          expect(Formulario.last.coordenador_id).to eq(admin_user.id)
        end

        it 'sets the data_envio to current time' do
          freeze_time do
            post :create, params: { formulario: valid_attributes }
            expect(Formulario.last.data_envio).to be_within(1.second).of(Time.current)
          end
        end

        it 'redirects to the created formulario' do
          post :create, params: { formulario: valid_attributes }
          expect(response).to redirect_to(Formulario.last)
        end

        it 'shows success notice' do
          post :create, params: { formulario: valid_attributes }
          expect(flash[:notice]).to eq('Formulário publicado com sucesso.')
        end
      end

      # Sad Path Tests
      context 'with invalid params' do
        it 'does not create a new Formulario' do
          expect {
            post :create, params: { formulario: invalid_attributes }
          }.not_to change(Formulario, :count)
        end

        it 'returns unprocessable entity status' do
          post :create, params: { formulario: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'renders the new template' do
          post :create, params: { formulario: invalid_attributes }
          expect(response).to render_template(:new)
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid params' do
        let(:new_attributes) { { ativo: false } }

        it 'updates the requested formulario' do
          put :update, params: { id: formulario.to_param, formulario: new_attributes }
          formulario.reload
          expect(formulario.ativo).to be_falsey
        end

        it 'redirects to the formulario' do
          put :update, params: { id: formulario.to_param, formulario: new_attributes }
          expect(response).to redirect_to(formulario)
        end

        it 'shows success notice' do
          put :update, params: { id: formulario.to_param, formulario: new_attributes }
          expect(flash[:notice]).to eq('Formulário atualizado com sucesso.')
        end
      end

      # Sad Path Tests
      context 'with invalid params' do
        it 'returns unprocessable entity status' do
          put :update, params: { id: formulario.to_param, formulario: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'renders the edit template' do
          put :update, params: { id: formulario.to_param, formulario: invalid_attributes }
          expect(response).to render_template(:edit)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested formulario' do
        formulario # Create the formulario
        expect {
          delete :destroy, params: { id: formulario.to_param }
        }.to change(Formulario, :count).by(-1)
      end

      it 'redirects to the formularios list' do
        delete :destroy, params: { id: formulario.to_param }
        expect(response).to redirect_to(formularios_url)
      end

      it 'shows success notice' do
        delete :destroy, params: { id: formulario.to_param }
        expect(flash[:notice]).to eq('Formulário removido com sucesso.')
      end
    end

    # JSON Response Tests
    describe 'JSON responses' do
      describe 'POST #create with JSON' do
        it 'returns JSON response for successful creation' do
          post :create, params: { formulario: valid_attributes }, format: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to include('application/json')
        end

        it 'returns JSON error for failed creation' do
          post :create, params: { formulario: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to include('application/json')
        end
      end

      describe 'PUT #update with JSON' do
        it 'returns JSON response for successful update' do
          put :update, params: { id: formulario.to_param, formulario: { ativo: false } }, format: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to include('application/json')
        end

        it 'returns JSON error for failed update' do
          put :update, params: { id: formulario.to_param, formulario: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to include('application/json')
        end
      end

      describe 'DELETE #destroy with JSON' do
        it 'returns no content for successful deletion' do
          delete :destroy, params: { id: formulario.to_param }, format: :json
          expect(response).to have_http_status(:no_content)
        end
      end
    end
  end

  describe 'when user is aluno' do
    let(:turma) { create(:turma) }
    let(:formulario_aluno) { create(:formulario, template: template, turma: turma, ativo: true) }
    let!(:matricula) { create(:matricula, user: aluno_user, turma: turma) }

    before do
      allow(controller).to receive(:current_user).and_return(aluno_user)
    end

    describe 'GET #show for students' do
      context 'when formulario is active and not answered' do
        it 'returns a success response' do
          get :show, params: { id: formulario_aluno.to_param }
          expect(response).to be_successful
        end

        it 'loads perguntas for the formulario' do
          pergunta = create(:perguntum, template: template)
          get :show, params: { id: formulario_aluno.to_param }
          expect(assigns(:perguntas)).to include(pergunta)
        end

        it 'initializes empty resposta hash' do
          get :show, params: { id: formulario_aluno.to_param }
          expect(assigns(:resposta)).to eq({})
        end
      end

      # Sad Path Tests
      context 'when formulario is not active' do
        before do
          formulario_aluno.update(ativo: false)
        end

        it 'redirects to evaluations path with alert' do
          get :show, params: { id: formulario_aluno.to_param }
          expect(response).to redirect_to(evaluations_path)
          expect(flash[:alert]).to include('não está mais disponível')
        end
      end

      context 'when already answered' do
        before do
          allow(formulario_aluno).to receive(:respondido_por?).with(aluno_user).and_return(true)
          allow(Formulario).to receive(:find).and_return(formulario_aluno)
        end

        it 'redirects to evaluations path with notice' do
          get :show, params: { id: formulario_aluno.to_param }
          expect(response).to redirect_to(evaluations_path)
          expect(flash[:notice]).to include('já respondeu')
        end
      end
    end

    describe 'POST #responder_formulario' do
      let!(:pergunta_subjetiva) { create(:perguntum, template: template, tipo: :subjetiva) }
      let!(:pergunta_multipla) { create(:perguntum, template: template, tipo: :multipla_escolha) }
      let!(:opcao) { create(:opcoes_perguntum, pergunta: pergunta_multipla) }

      context 'with valid responses' do
        let(:valid_params) do
          {
            id: formulario_aluno.id,
            respostas: {
              pergunta_subjetiva.id.to_s => 'Minha resposta',
              pergunta_multipla.id.to_s => opcao.id.to_s
            }
          }
        end

        it 'creates responses successfully' do
          expect {
            post :responder_formulario, params: valid_params
          }.to change(Respostum, :count).by(2)
        end

        it 'creates submission record' do
          expect {
            post :responder_formulario, params: valid_params
          }.to change(SubmissaoConcluida, :count).by(1)
        end

        it 'redirects with success message' do
          post :responder_formulario, params: valid_params
          expect(response).to redirect_to(evaluations_path)
          expect(flash[:notice]).to eq('Formulário enviado com sucesso!')
        end
      end

      # Sad Path Tests
      context 'when formulario is not active' do
        before do
          formulario_aluno.update(ativo: false)
        end

        it 'redirects with error message' do
          post :responder_formulario, params: { id: formulario_aluno.id, respostas: {} }
          expect(response).to redirect_to(evaluations_path)
          expect(flash[:alert]).to include('não está mais disponível')
        end
      end

      context 'when already answered' do
        before do
          allow(formulario_aluno).to receive(:respondido_por?).with(aluno_user).and_return(true)
          allow(Formulario).to receive(:find).and_return(formulario_aluno)
        end

        it 'redirects with notice' do
          post :responder_formulario, params: { id: formulario_aluno.id, respostas: {} }
          expect(response).to redirect_to(evaluations_path)
          expect(flash[:notice]).to include('já respondeu')
        end
      end

      context 'when transaction fails' do
        before do
          allow(Respostum).to receive(:create!).and_raise(ActiveRecord::RecordInvalid.new(Respostum.new))
        end

        it 'handles errors and redirects with error message' do
          post :responder_formulario, params: {
            id: formulario_aluno.id,
            respostas: { pergunta_subjetiva.id.to_s => 'teste' }
          }
          expect(response).to redirect_to(formulario_path(formulario_aluno))
          expect(flash[:alert]).to include('Erro ao salvar respostas')
        end
      end
    end
  end

  describe 'utility methods' do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    describe '#gerar_uuid_anonimo' do
      let(:formulario_test) { create(:formulario, template: template) }

      before do
        controller.instance_variable_set(:@formulario, formulario_test)
      end

      it 'generates consistent UUID for same user and formulario' do
        uuid1 = controller.send(:gerar_uuid_anonimo, aluno_user)
        uuid2 = controller.send(:gerar_uuid_anonimo, aluno_user)
        
        expect(uuid1).to eq(uuid2)
        expect(uuid1).to be_a(String)
        expect(uuid1.length).to eq(64) # SHA256 hex string length
      end

      it 'generates different UUIDs for different users' do
        other_user = create(:user, role: :aluno)
        
        uuid1 = controller.send(:gerar_uuid_anonimo, aluno_user)
        uuid2 = controller.send(:gerar_uuid_anonimo, other_user)
        
        expect(uuid1).not_to eq(uuid2)
      end

      it 'uses consistent digest format' do
        uuid = controller.send(:gerar_uuid_anonimo, aluno_user)
        expected_uuid = Digest::SHA256.hexdigest(aluno_user.id.to_s + formulario_test.id.to_s)
        expect(uuid).to eq(expected_uuid)
      end
    end
  end

  # Error handling tests
  describe 'error handling' do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    describe 'when formulario not found' do
      it 'raises ActiveRecord::RecordNotFound' do
        expect {
          get :show, params: { id: 'nonexistent' }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
