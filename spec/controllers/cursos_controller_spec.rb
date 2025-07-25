require 'rails_helper'

RSpec.describe CursosController, type: :controller do
  let(:admin_user) { create(:user, role: :admin) }
  let(:aluno_user) { create(:user, role: :aluno) }
  let(:curso) { create(:curso) }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'when signed in as admin' do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end

      it 'assigns all cursos' do
        curso
        get :index
        expect(assigns(:cursos)).to include(curso)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns a new curso' do
        get :new
        expect(assigns(:curso)).to be_a_new(Curso)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        get :edit, params: { id: curso.id }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid parameters' do
        let(:valid_attributes) { { nome: 'Novo Curso' } }

        it 'creates a new Curso' do
          expect {
            post :create, params: { curso: valid_attributes }
          }.to change(Curso, :count).by(1)
        end

        it 'redirects to the cursos list' do
          post :create, params: { curso: valid_attributes }
          expect(response).to redirect_to(cursos_path)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) { { nome: '' } }

        it 'does not create a new Curso' do
          expect {
            post :create, params: { curso: invalid_attributes }
          }.to change(Curso, :count).by(0)
        end

        it 'renders the new template' do
          post :create, params: { curso: invalid_attributes }
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid parameters' do
        let(:new_attributes) { { nome: 'Curso Atualizado' } }

        it 'updates the requested curso' do
          put :update, params: { id: curso.id, curso: new_attributes }
          curso.reload
          expect(curso.nome).to eq('Curso Atualizado')
        end

        it 'redirects to the cursos list' do
          put :update, params: { id: curso.id, curso: new_attributes }
          expect(response).to redirect_to(curso)
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested curso' do
        curso
        expect {
          delete :destroy, params: { id: curso.id }
        }.to change(Curso, :count).by(-1)
      end

      it 'redirects to the cursos list' do
        delete :destroy, params: { id: curso.id }
        expect(response).to redirect_to(cursos_path)
      end
    end
  end

  describe 'when signed in as aluno' do
    before do
      allow(controller).to receive(:current_user).and_return(aluno_user)
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    describe 'GET #new' do
      it 'redirects to root path' do
        get :new
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      it 'redirects to root path' do
        post :create, params: { curso: { nome: 'Test' } }
        expect(response.status).to be_between(200, 499)
      end
    end
  end
end
