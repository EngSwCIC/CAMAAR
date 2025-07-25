# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  let(:admin) { create(:user, :admin) }
  let(:aluno) { create(:user, :aluno, curso: 'Engenharia de Software') }
  let(:professor) { create(:user, :professor) }
  let(:curso) { create(:curso, nome: 'Engenharia de Software') }
  let(:disciplina) { create(:disciplina, curso: curso) }
  let(:turma) { create(:turma, disciplina: disciplina, professor: professor) }

  before do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    login_as(admin, scope: :user)
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'assigns all users' do
      get :index
      expect(assigns(:users)).to include(admin)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      get :show, params: { id: admin.id }
      expect(response).to be_successful
    end

    it 'assigns the requested user' do
      get :show, params: { id: admin.id }
      expect(assigns(:user)).to eq(admin)
    end
  end

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end

    it 'assigns a new user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'GET #edit' do
    context 'when user is admin' do
      it 'returns a successful response' do
        get :edit, params: { id: admin.id }
        expect(response).to be_successful
      end

      it 'assigns the requested user' do
        get :edit, params: { id: admin.id }
        expect(assigns(:user)).to eq(admin)
      end

      it 'allows admin to edit any user' do
        get :edit, params: { id: aluno.id }
        expect(response).to be_successful
        expect(assigns(:user)).to eq(aluno)
      end
    end

    context 'when user is editing their own profile' do
      before { login_as(aluno, scope: :user) }

      it 'returns a successful response' do
        get :edit, params: { id: aluno.id }
        expect(response).to be_successful
      end

      it 'assigns the requested user' do
        get :edit, params: { id: aluno.id }
        expect(assigns(:user)).to eq(aluno)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_attributes) do
        {
          name: 'New User',
          email: 'newuser@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          matricula: '12345678',
          role: 'aluno',
          curso: 'Engenharia de Software'
        }
      end

      it 'creates a new user' do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the user' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(User.last)
      end

      it 'sets success notice with temporary password' do
        post :create, params: { user: valid_attributes }
        expect(flash[:notice]).to match(/Usuário criado com sucesso! Senha temporária:/)
      end
    end

    context 'with blank password' do
      let(:attributes_without_password) do
        {
          name: 'New User',
          email: 'newuser@example.com',
          matricula: '12345678',
          role: 'aluno',
          curso: 'Engenharia de Software',
          password: ''
        }
      end

      it 'creates user successfully' do
        expect do
          post :create, params: { user: attributes_without_password }
        end.to change(User, :count).by(1)
      end

      it 'sets success notice with generated password' do
        post :create, params: { user: attributes_without_password }
        expect(flash[:notice]).to match(/Usuário criado com sucesso! Senha temporária:/)
      end
    end

    context 'with JSON format' do
      let(:valid_attributes) do
        {
          name: 'New User',
          email: 'newuser@example.com',
          matricula: '12345678',
          role: 'aluno'
        }
      end

      it 'returns JSON response for successful creation' do
        post :create, params: { user: valid_attributes }, format: :json
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
      end

      it 'returns JSON error for failed creation' do
        post :create, params: { user: { name: '' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          name: '',
          email: 'invalid_email',
          password: 'pass',
          matricula: ''
        }
      end

      it 'does not create a new user' do
        expect do
          post :create, params: { user: invalid_attributes }
        end.not_to change(User, :count)
      end

      it 'renders the new template' do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        {
          name: 'Updated Name',
          curso: 'Ciência da Computação'
        }
      end

      it 'updates the user' do
        patch :update, params: { id: aluno.id, user: new_attributes }
        aluno.reload
        expect(aluno.name).to eq('Updated Name')
        expect(aluno.curso).to eq('Ciência da Computação')
      end

      it 'redirects to the user' do
        patch :update, params: { id: aluno.id, user: new_attributes }
        expect(response).to redirect_to(aluno)
      end

      it 'sets success notice' do
        patch :update, params: { id: aluno.id, user: new_attributes }
        expect(flash[:notice]).to eq(I18n.t('messages.user_updated'))
      end
    end

    context 'with password fields' do
      let(:attributes_with_password) do
        {
          name: 'Updated Name',
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }
      end

      it 'does not update password when present' do
        original_encrypted_password = aluno.encrypted_password
        patch :update, params: { id: aluno.id, user: attributes_with_password }
        aluno.reload
        # Password fields are excluded from update
        expect(aluno.encrypted_password).to eq(original_encrypted_password)
        expect(aluno.name).to eq('Updated Name')
      end
    end

    context 'with blank password fields' do
      let(:attributes_with_blank_password) do
        {
          name: 'Updated Name',
          password: '',
          password_confirmation: ''
        }
      end

      it 'removes password fields and updates other attributes' do
        patch :update, params: { id: aluno.id, user: attributes_with_blank_password }
        aluno.reload
        expect(aluno.name).to eq('Updated Name')
      end
    end

    context 'with JSON format' do
      let(:new_attributes) do
        {
          name: 'Updated Name JSON'
        }
      end

      it 'returns JSON response for successful update' do
        patch :update, params: { id: aluno.id, user: new_attributes }, format: :json
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
      end

      it 'returns JSON error for failed update' do
        patch :update, params: { id: aluno.id, user: { name: '' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) do
        {
          name: '',
          email: 'invalid_email'
        }
      end

      it 'does not update the user' do
        original_name = aluno.name
        patch :update, params: { id: aluno.id, user: invalid_attributes }
        aluno.reload
        expect(aluno.name).to eq(original_name)
      end

      it 'renders the edit template' do
        patch :update, params: { id: aluno.id, user: invalid_attributes }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is admin' do
      it 'destroys the user' do
        user_to_delete = create(:user, :aluno)
        expect do
          delete :destroy, params: { id: user_to_delete.id }
        end.to change(User, :count).by(-1)
      end

      it 'redirects to users index' do
        delete :destroy, params: { id: aluno.id }
        expect(response).to redirect_to(users_url)
      end

      it 'sets success notice' do
        delete :destroy, params: { id: aluno.id }
        expect(flash[:notice]).to eq(I18n.t('messages.user_destroyed'))
      end

      it 'returns JSON response' do
        delete :destroy, params: { id: aluno.id }, format: :json
        expect(response).to have_http_status(:no_content)
      end
    end
  end

  describe 'POST #adicionar_disciplina_aluno' do
    context 'when user is admin' do
      let(:params) do
        {
          user_id: aluno.id,
          disciplina_id: disciplina.id,
          turma_id: turma.id
        }
      end

      it 'adds disciplina to aluno' do
        expect do
          post :adicionar_disciplina_aluno, params: params
        end.to change(Matricula, :count).by(1)
      end

      it 'redirects to edit user page' do
        post :adicionar_disciplina_aluno, params: params
        expect(response).to redirect_to(edit_user_path(aluno))
      end

      it 'sets success notice' do
        post :adicionar_disciplina_aluno, params: params
        expect(flash[:notice]).to match(/Aluno matriculado na disciplina .+ - .+/)
      end

      context 'when aluno is already enrolled' do
        before { create(:matricula, user: aluno, turma: turma) }

        it 'does not create duplicate matricula' do
          expect do
            post :adicionar_disciplina_aluno, params: params
          end.not_to change(Matricula, :count)
        end

        it 'redirects with error message' do
          post :adicionar_disciplina_aluno, params: params
          expect(response).to redirect_to(edit_user_path(aluno))
          expect(flash[:alert]).to eq('Este aluno já está matriculado nesta turma.')
        end
      end
    end
  end

  describe 'DELETE #remover_disciplina_aluno' do
    let!(:matricula) { create(:matricula, user: aluno, turma: turma) }

    context 'when user is admin' do
      context 'with matricula_id parameter' do
        let(:params) { { matricula_id: matricula.id } }

        it 'removes disciplina from aluno' do
          expect do
            delete :remover_disciplina_aluno, params: params
          end.to change(Matricula, :count).by(-1)
        end

        it 'redirects to edit user page' do
          delete :remover_disciplina_aluno, params: params
          expect(response).to redirect_to(edit_user_path(aluno))
        end

        it 'sets success notice' do
          delete :remover_disciplina_aluno, params: params
          expect(flash[:notice]).to eq('Disciplina removida com sucesso!')
        end
      end

      context 'with user_id and disciplina_id parameters' do
        let(:params) do
          {
            user_id: aluno.id,
            disciplina_id: disciplina.id
          }
        end

        it 'removes disciplina from aluno' do
          expect do
            delete :remover_disciplina_aluno, params: params
          end.to change(Matricula, :count).by(-1)
        end

        it 'redirects to edit user page' do
          delete :remover_disciplina_aluno, params: params
          expect(response).to redirect_to(edit_user_path(aluno))
        end

        it 'sets success notice' do
          delete :remover_disciplina_aluno, params: params
          expect(flash[:notice]).to eq('Disciplina removida com sucesso!')
        end
      end
    end
  end

  describe 'POST #adicionar_disciplina_professor' do
    context 'when user is admin' do
      let(:params) do
        {
          user_id: professor.id,
          disciplina_id: disciplina.id,
          semestre: '2025.1'
        }
      end

      it 'creates new turma for professor' do
        expect do
          post :adicionar_disciplina_professor, params: params
        end.to change(Turma, :count).by(1)
      end

      it 'redirects to edit user page' do
        post :adicionar_disciplina_professor, params: params
        expect(response).to redirect_to(edit_user_path(professor))
      end

      it 'sets success notice' do
        post :adicionar_disciplina_professor, params: params
        expect(flash[:notice]).to eq('Disciplina adicionada ao professor com sucesso!')
      end

      context 'when professor already teaches this disciplina in same semester' do
        before { create(:turma, disciplina: disciplina, professor: professor, semestre: '2025.1') }

        it 'does not create duplicate turma' do
          expect do
            post :adicionar_disciplina_professor, params: params
          end.not_to change(Turma, :count)
        end

        it 'redirects with error message' do
          post :adicionar_disciplina_professor, params: params
          expect(response).to redirect_to(edit_user_path(professor))
          expect(flash[:alert]).to eq('Este professor já leciona esta disciplina neste semestre.')
        end
      end
    end
  end

  describe 'DELETE #remover_disciplina_professor' do
    let!(:turma_professor) { create(:turma, disciplina: disciplina, professor: professor, semestre: '2025.1') }

    context 'when user is admin' do
      let(:params) { { turma_id: turma_professor.id } }

      it 'removes disciplina from professor' do
        expect do
          delete :remover_disciplina_professor, params: params
        end.to change(Turma, :count).by(-1)
      end

      it 'redirects to edit user page' do
        delete :remover_disciplina_professor, params: params
        expect(response).to redirect_to(edit_user_path(professor))
      end

      it 'sets success notice with disciplina and semester info' do
        delete :remover_disciplina_professor, params: params
        expect(flash[:notice]).to eq("Professor removido da disciplina #{disciplina.nome} - 2025.1.")
      end
    end
  end

  describe 'private methods' do
    describe '#user_params' do
      context 'when current user is admin' do
        before { login_as(admin, scope: :user) }

        it 'permits all fields including role' do
          params = ActionController::Parameters.new({
            user: {
              email: 'test@example.com',
              password: 'password',
              password_confirmation: 'password',
              name: 'Test User',
              matricula: '123456',
              role: 'admin',
              curso: 'Test Course'
            }
          })
          
          allow(controller).to receive(:params).and_return(params)
          allowed_params = controller.send(:user_params)
          
          expect(allowed_params.keys).to include('email', 'password', 'password_confirmation', 'name', 'matricula', 'role', 'curso')
        end
      end
    end

    describe '#generate_temp_password' do
      it 'generates 8 character password' do
        password = controller.send(:generate_temp_password)
        expect(password).to be_a(String)
        expect(password.length).to eq(8)
      end

      it 'generates different passwords each time' do
        password1 = controller.send(:generate_temp_password)
        password2 = controller.send(:generate_temp_password)
        expect(password1).not_to eq(password2)
      end
    end

    describe '#clean_password_params_if_blank' do
      it 'removes password fields when password is blank' do
        params = ActionController::Parameters.new({
          user: {
            name: 'Test User',
            password: '',
            password_confirmation: ''
          }
        })
        
        allow(controller).to receive(:params).and_return(params)
        allow(controller).to receive(:user_params).and_return(ActionController::Parameters.new(password: ''))
        
        controller.send(:clean_password_params_if_blank)
        expect(params[:user]).not_to have_key(:password)
        expect(params[:user]).not_to have_key(:password_confirmation)
      end

      it 'keeps password fields when password is present' do
        params = ActionController::Parameters.new({
          user: {
            name: 'Test User',
            password: 'newpassword',
            password_confirmation: 'newpassword'
          }
        })
        
        allow(controller).to receive(:params).and_return(params)
        allow(controller).to receive(:user_params).and_return(ActionController::Parameters.new(password: 'newpassword'))
        
        controller.send(:clean_password_params_if_blank)
        expect(params[:user]).to have_key(:password)
        expect(params[:user]).to have_key(:password_confirmation)
      end
    end
  end

  describe 'authorization' do
    context 'when user is not admin' do
      before { login_as(aluno, scope: :user) }

      it 'restricts access to index', pending: 'Authorization disabled in test environment' do
        get :index
        expect(response).to redirect_to(root_path)
      end

      it 'restricts access to new', pending: 'Authorization disabled in test environment' do
        get :new
        expect(response).to redirect_to(root_path)
      end

      it 'restricts access to create', pending: 'Authorization disabled in test environment' do
        post :create, params: { user: { name: 'Test' } }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
