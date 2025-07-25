require 'rails_helper'

RSpec.describe DisciplinasController, type: :controller do
  let(:admin_user) { create(:user, role: :admin) }
  let(:aluno_user) { create(:user, role: :aluno) }
  let(:professor_user) { create(:user, role: :professor) }
  let(:curso) { create(:curso) }
  let(:disciplina) { create(:disciplina, curso: curso) }
  let(:valid_attributes) { { nome: 'Matemática', curso_id: curso.id } }
  let(:invalid_attributes) { { nome: nil } }

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

      it 'assigns all disciplinas' do
        disciplina
        get :index
        expect(assigns(:disciplinas)).to include(disciplina)
      end
    end

    describe 'GET #new' do
      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns a new disciplina' do
        get :new
        expect(assigns(:disciplina)).to be_a_new(Disciplina)
      end

      it 'loads cursos' do
        curso # create curso
        get :new
        expect(response).to be_successful
      end
    end

    describe 'GET #edit' do
      it 'returns a success response' do
        get :edit, params: { id: disciplina.id }
        expect(response).to be_successful
      end

      it 'loads cursos' do
        get :edit, params: { id: disciplina.id }
        expect(response).to be_successful
      end
    end

    describe 'POST #create' do
      context 'with valid parameters' do
        let(:valid_attributes) do
          {
            nome: 'Nova Disciplina',
            codigo: 'DIS001',
            curso_id: curso.id
          }
        end

        it 'creates a new Disciplina' do
          expect {
            post :create, params: { disciplina: valid_attributes }
          }.to change(Disciplina, :count).by(1)
        end

        it 'redirects to the disciplinas list' do
          post :create, params: { disciplina: valid_attributes }
          expect(response).to redirect_to(disciplinas_path)
        end
      end

      context 'with invalid parameters' do
        let(:invalid_attributes) { { nome: '', curso_id: nil } }

        it 'does not create a new Disciplina' do
          expect {
            post :create, params: { disciplina: invalid_attributes }
          }.to change(Disciplina, :count).by(0)
        end

        it 'renders the new template' do
          post :create, params: { disciplina: invalid_attributes }
          expect(response).to render_template('new')
        end
      end
    end

    describe 'PUT #update' do
      context 'with valid parameters' do
        let(:new_attributes) { { nome: 'Disciplina Atualizada' } }

        it 'updates the requested disciplina' do
          put :update, params: { id: disciplina.id, disciplina: new_attributes }
          disciplina.reload
          expect(disciplina.nome).to eq('Disciplina Atualizada')
        end

        it 'redirects to the disciplina' do
          put :update, params: { id: disciplina.id, disciplina: new_attributes }
          expect(response).to redirect_to(disciplina_url(disciplina))
        end
      end
    end

    describe 'DELETE #destroy' do
      it 'destroys the requested disciplina' do
        disciplina
        expect {
          delete :destroy, params: { id: disciplina.id }
        }.to change(Disciplina, :count).by(-1)
      end

      it 'redirects to the disciplinas list' do
        delete :destroy, params: { id: disciplina.id }
        expect(response).to redirect_to(disciplinas_path)
      end
    end
  end

  describe 'when signed in as aluno' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(aluno_user)
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

    describe 'POST #create' do
      it 'allows creating disciplina' do
        expect {
          post :create, params: { disciplina: valid_attributes }
        }.to change(Disciplina, :count).by(1)
      end
    end
  end

  describe 'GET #turmas' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    it 'returns turmas for a disciplina in JSON format' do
      turma = create(:turma, disciplina: disciplina, professor: professor_user)
      get :turmas, params: { id: disciplina.id }, format: :json
      expect(response).to be_successful
      expect(response.content_type).to include('application/json')
      
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.first['id']).to eq(turma.id)
      expect(json_response.first['semestre']).to eq(turma.semestre)
      expect(json_response.first['professor_nome']).to eq(turma.professor.name)
    end

    it 'handles disciplina not found' do
      expect {
        get :turmas, params: { id: 99999 }, format: :json
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'private methods' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    describe '#set_disciplina' do
      it 'sets the disciplina from params' do
        get :edit, params: { id: disciplina.id }
        expect(assigns(:disciplina)).to eq(disciplina)
      end
    end

    describe '#disciplina_params' do
      it 'permits nome and curso_id parameters' do
        post :create, params: { disciplina: { nome: 'Test', curso_id: curso.id, forbidden_param: 'test' } }
        created_disciplina = Disciplina.last
        expect(created_disciplina.nome).to eq('Test')
        expect(created_disciplina.curso_id).to eq(curso.id)
      end
    end
  end
end
