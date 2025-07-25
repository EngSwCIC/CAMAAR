require 'rails_helper'

RSpec.describe MatriculasController, type: :controller do
  let(:admin_user) { create(:user, role: :admin) }
  let(:aluno_user) { create(:user, role: :aluno) }
  let(:professor_user) { create(:user, role: :professor) }
  let(:coordenador_user) { create(:user, role: :coordenador) }
  let(:disciplina) { create(:disciplina) }
  let(:turma) { create(:turma, disciplina: disciplina, professor: professor_user) }
  let(:matricula) { create(:matricula, user: aluno_user, turma: turma) }
  let(:valid_attributes) { { user_id: aluno_user.id, turma_id: turma.id } }
  let(:invalid_attributes) { { user_id: nil, turma_id: nil } }

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

      it 'assigns all matriculas' do
        matricula
        get :index
        expect(assigns(:matriculas)).to include(matricula)
      end

      it 'responds to JSON format' do
        matricula
        get :index, format: :json
        expect(response).to be_successful
        expect(response.content_type).to include('application/json')
      end
    end

    describe 'GET #show' do
      it 'returns a success response' do
        get :show, params: { id: matricula.to_param }
        expect(response).to be_successful
      end

      it 'assigns the requested matricula' do
        get :show, params: { id: matricula.to_param }
        expect(assigns(:matricula)).to eq(matricula)
      end

      it 'responds to JSON format' do
        get :show, params: { id: matricula.to_param }, format: :json
        expect(response).to be_successful
        expect(response.content_type).to include('application/json')
      end

      it 'raises error for non-existent matricula' do
        expect {
          get :show, params: { id: 99999 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns a new matricula' do
        get :new
        expect(assigns(:matricula)).to be_a_new(Matricula)
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        get :edit, params: { id: matricula.to_param }
        expect(response).to be_successful
      end

      it 'assigns the requested matricula' do
        get :edit, params: { id: matricula.to_param }
        expect(assigns(:matricula)).to eq(matricula)
      end
    end

    describe 'POST #create' do
      context 'with valid parameters' do
        it 'creates a new Matricula' do
          expect {
            post :create, params: { matricula: valid_attributes }
          }.to change(Matricula, :count).by(1)
        end

        it 'redirects to the created matricula' do
          post :create, params: { matricula: valid_attributes }
          expect(response).to redirect_to(Matricula.last)
        end

        it 'responds with success in JSON format' do
          post :create, params: { matricula: valid_attributes }, format: :json
          expect(response).to have_http_status(:created)
          expect(response.content_type).to include('application/json')
        end

        it 'sets success notice' do
          post :create, params: { matricula: valid_attributes }
          expect(flash[:notice]).to eq('Matricula was successfully created.')
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Matricula' do
          expect {
            post :create, params: { matricula: invalid_attributes }
          }.to change(Matricula, :count).by(0)
        end

        it 'renders the new template' do
          post :create, params: { matricula: invalid_attributes }
          expect(response).to render_template(:new)
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'responds with errors in JSON format' do
          post :create, params: { matricula: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to include('application/json')
        end
      end
    end

    describe 'PUT/PATCH #update' do
      context 'with valid parameters' do
        let(:new_turma) { create(:turma, disciplina: disciplina, professor: professor_user) }
        let(:new_attributes) { { turma_id: new_turma.id } }

        it 'updates the requested matricula' do
          patch :update, params: { id: matricula.to_param, matricula: new_attributes }
          matricula.reload
          expect(matricula.turma_id).to eq(new_turma.id)
        end

        it 'redirects to the matricula' do
          patch :update, params: { id: matricula.to_param, matricula: new_attributes }
          expect(response).to redirect_to(matricula)
        end

        it 'responds with success in JSON format' do
          patch :update, params: { id: matricula.to_param, matricula: new_attributes }, format: :json
          expect(response).to have_http_status(:ok)
          expect(response.content_type).to include('application/json')
        end

        it 'sets success notice' do
          patch :update, params: { id: matricula.to_param, matricula: new_attributes }
          expect(flash[:notice]).to eq('Matricula was successfully updated.')
        end
      end

      context 'with invalid parameters' do
        it 'renders the edit template' do
          patch :update, params: { id: matricula.to_param, matricula: invalid_attributes }
          expect(response).to render_template(:edit)
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'responds with errors in JSON format' do
          patch :update, params: { id: matricula.to_param, matricula: invalid_attributes }, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to include('application/json')
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested matricula' do
        matricula
        expect {
          delete :destroy, params: { id: matricula.to_param }
        }.to change(Matricula, :count).by(-1)
      end

      it 'redirects to the matriculas list' do
        delete :destroy, params: { id: matricula.to_param }
        expect(response).to redirect_to(matriculas_path)
        expect(response).to have_http_status(:see_other)
      end

      it 'responds with no content in JSON format' do
        delete :destroy, params: { id: matricula.to_param }, format: :json
        expect(response).to have_http_status(:no_content)
      end

      it 'sets success notice' do
        delete :destroy, params: { id: matricula.to_param }
        expect(flash[:notice]).to eq('Matricula was successfully destroyed.')
      end
    end
  end

  describe 'when user is coordenador' do
    before do
      allow(controller).to receive(:current_user).and_return(coordenador_user)
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      it 'allows creating matricula' do
        expect {
          post :create, params: { matricula: valid_attributes }
        }.to change(Matricula, :count).by(1)
      end
    end

    describe 'PATCH #update' do
      it 'allows updating matricula' do
        new_turma = create(:turma, disciplina: disciplina, professor: professor_user)
        patch :update, params: { id: matricula.to_param, matricula: { turma_id: new_turma.id } }
        matricula.reload
        expect(matricula.turma_id).to eq(new_turma.id)
      end
    end

    describe 'DELETE #destroy' do
      it 'allows destroying matricula' do
        matricula
        expect {
          delete :destroy, params: { id: matricula.to_param }
        }.to change(Matricula, :count).by(-1)
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

    describe 'POST #create' do
      it 'allows creating matricula' do
        expect {
          post :create, params: { matricula: valid_attributes }
        }.to change(Matricula, :count).by(1)
      end
    end

    describe 'PATCH #update' do
      it 'allows updating matricula' do
        new_turma = create(:turma, disciplina: disciplina, professor: professor_user)
        patch :update, params: { id: matricula.to_param, matricula: { turma_id: new_turma.id } }
        matricula.reload
        expect(matricula.turma_id).to eq(new_turma.id)
      end
    end

    describe 'DELETE #destroy' do
      it 'allows destroying matricula' do
        matricula
        expect {
          delete :destroy, params: { id: matricula.to_param }
        }.to change(Matricula, :count).by(-1)
      end
    end
  end

  describe 'when user is aluno' do
    before do
      allow(controller).to receive(:current_user).and_return(aluno_user)
    end

    describe 'GET #index' do
      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      it 'allows creating matricula' do
        expect {
          post :create, params: { matricula: valid_attributes }
        }.to change(Matricula, :count).by(1)
      end
    end

    describe 'PATCH #update' do
      it 'allows updating matricula' do
        new_turma = create(:turma, disciplina: disciplina, professor: professor_user)
        patch :update, params: { id: matricula.to_param, matricula: { turma_id: new_turma.id } }
        matricula.reload
        expect(matricula.turma_id).to eq(new_turma.id)
      end
    end

    describe 'DELETE #destroy' do
      it 'allows destroying matricula' do
        matricula
        expect {
          delete :destroy, params: { id: matricula.to_param }
        }.to change(Matricula, :count).by(-1)
      end
    end
  end

  describe 'private methods' do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    describe '#set_matricula' do
      it 'sets the matricula for show action' do
        get :show, params: { id: matricula.to_param }
        expect(assigns(:matricula)).to eq(matricula)
      end

      it 'sets the matricula for edit action' do
        get :edit, params: { id: matricula.to_param }
        expect(assigns(:matricula)).to eq(matricula)
      end
    end

    describe '#matricula_params' do
      it 'permits user_id and turma_id parameters' do
        post :create, params: { matricula: { user_id: aluno_user.id, turma_id: turma.id, forbidden_param: 'test' } }
        created_matricula = Matricula.last
        expect(created_matricula.user_id).to eq(aluno_user.id)
        expect(created_matricula.turma_id).to eq(turma.id)
      end
    end
  end
end
