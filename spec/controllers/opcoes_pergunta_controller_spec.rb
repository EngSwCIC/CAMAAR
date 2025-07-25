require 'rails_helper'

RSpec.describe OpcoesPerguntaController, type: :controller do
  let(:admin_user) { create(:user, role: :admin) }
  let(:professor_user) { create(:user, role: :professor) }
  let(:aluno_user) { create(:user, role: :aluno) }
  let(:template) { create(:template, criado_por: admin_user) }
  let(:pergunta) { create(:perguntum, template: template) }
  let(:opcoes_perguntum) { create(:opcoes_perguntum, pergunta: pergunta) }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'when user is admin' do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end

      it 'assigns all opcoes_pergunta' do
        opcoes_perguntum
        get :index
        expect(assigns(:opcoes_pergunta)).to include(opcoes_perguntum)
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        get :show, params: { id: opcoes_perguntum.to_param }
        expect(response).to be_successful
      end

      it 'assigns the requested opcoes_perguntum' do
        get :show, params: { id: opcoes_perguntum.to_param }
        expect(assigns(:opcoes_perguntum)).to eq(opcoes_perguntum)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns a new opcoes_perguntum' do
        get :new
        expect(assigns(:opcoes_perguntum)).to be_a_new(OpcoesPerguntum)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        get :edit, params: { id: opcoes_perguntum.to_param }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      let(:valid_attributes) do
        {
          texto: 'Opção teste',
          pergunta_id: pergunta.id
        }
      end

      context 'with valid parameters' do
        it 'creates a new OpcoesPerguntum' do
          expect {
            post :create, params: { opcoes_perguntum: valid_attributes }
          }.to change(OpcoesPerguntum, :count).by(1)
        end

        it 'redirects to the created opcoes_perguntum' do
          post :create, params: { opcoes_perguntum: valid_attributes }
          expect(response).to redirect_to(OpcoesPerguntum.last)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) { { texto: '' } }

        it 'does not create a new OpcoesPerguntum' do
          expect {
            post :create, params: { opcoes_perguntum: invalid_attributes }
          }.to change(OpcoesPerguntum, :count).by(0)
        end

        it 'renders the new template' do
          post :create, params: { opcoes_perguntum: invalid_attributes }
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid parameters' do
        let(:new_attributes) { { texto: 'Opção atualizada' } }

        it 'updates the requested opcoes_perguntum' do
          put :update, params: { id: opcoes_perguntum.to_param, opcoes_perguntum: new_attributes }
          opcoes_perguntum.reload
          expect(opcoes_perguntum.texto).to eq('Opção atualizada')
        end

        it 'redirects to the opcoes_perguntum' do
          put :update, params: { id: opcoes_perguntum.to_param, opcoes_perguntum: new_attributes }
          expect(response).to redirect_to(opcoes_perguntum)
        end
      end

      context 'with invalid parameters' do
        it 'renders the edit template' do
          put :update, params: { id: opcoes_perguntum.to_param, opcoes_perguntum: { texto: '' } }
          expect(response).to render_template('edit')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested opcoes_perguntum' do
        opcoes_perguntum
        expect {
          delete :destroy, params: { id: opcoes_perguntum.to_param }
        }.to change(OpcoesPerguntum, :count).by(-1)
      end

      it 'redirects to the opcoes_pergunta list' do
        delete :destroy, params: { id: opcoes_perguntum.to_param }
        expect(response).to redirect_to(opcoes_pergunta_url)
      end
    end
  end

  describe 'when user is professor' do
    before do
      allow(controller).to receive(:current_user).and_return(professor_user)
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end
    end
  end

  describe 'when user is aluno' do
    before do
      allow(controller).to receive(:current_user).and_return(aluno_user)
    end

    describe 'GET #index' do
      it 'returns success' do
        get :index
        expect(response).to be_successful
      end
    end
  end
end
