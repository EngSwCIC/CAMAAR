require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin_user) { create(:user, role: 'admin') }
  let(:non_admin_user) { create(:user, role: 'aluno') }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET #new' do
    context 'when user is admin' do
      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
      end

      it 'returns a success response' do
        get :new
        expect(response).to be_successful
      end

      it 'assigns a new user' do
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end

      it 'renders the new template' do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context 'when user is not admin' do
      before do
        allow(controller).to receive(:current_user).and_return(non_admin_user)
      end

      it 'redirects to root path' do
        get :new
        expect(response).to redirect_to(root_path)
      end

      it 'sets access denied alert' do
        get :new
        expect(flash[:alert]).to eq(I18n.t('messages.access_denied'))
      end
    end
  end

  describe 'POST #create' do
    let(:valid_attributes) do
      {
        email: 'test@example.com',
        name: 'Test User',
        matricula: '12345',
        role: 'aluno'
      }
    end

    let(:invalid_attributes) do
      {
        email: '',
        name: '',
        matricula: '',
        role: ''
      }
    end

    context 'when user is admin' do
      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
      end

      context 'with valid parameters' do
        it 'creates a new user' do
          expect {
            post :create, params: { user: valid_attributes }
          }.to change(User, :count).by(1)
        end

        it 'redirects to users path' do
          post :create, params: { user: valid_attributes }
          expect(response).to redirect_to(users_path)
        end

        it 'sets success notice' do
          post :create, params: { user: valid_attributes }
          expect(flash[:notice]).to include('Usuário criado com sucesso!')
        end

        it 'includes temporary password in notice' do
          post :create, params: { user: valid_attributes }
          created_user = User.last
          expect(flash[:notice]).to include("Senha temporária: #{created_user.password}")
        end

        it 'assigns the user' do
          post :create, params: { user: valid_attributes }
          expect(assigns(:user)).to be_a(User)
          expect(assigns(:user)).to be_persisted
        end
      end

      context 'with valid parameters including password' do
        let(:attributes_with_password) do
          valid_attributes.merge(
            password: 'custom_password',
            password_confirmation: 'custom_password'
          )
        end

        it 'uses provided password' do
          post :create, params: { user: attributes_with_password }
          created_user = User.last
          expect(created_user.valid_password?('custom_password')).to be true
        end

        it 'does not generate temporary password' do
          expect(controller).not_to receive(:generate_temp_password)
          post :create, params: { user: attributes_with_password }
        end
      end

      context 'without password provided' do
        it 'generates temporary password' do
          allow(controller).to receive(:generate_temp_password).and_return('temp1234')
          
          post :create, params: { user: valid_attributes }
          created_user = User.last
          expect(created_user.valid_password?('temp1234')).to be true
        end

        it 'calls generate_temp_password' do
          expect(controller).to receive(:generate_temp_password).and_call_original
          post :create, params: { user: valid_attributes }
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new user' do
          expect {
            post :create, params: { user: invalid_attributes }
          }.not_to change(User, :count)
        end

        it 'renders new template' do
          post :create, params: { user: invalid_attributes }
          expect(response).to render_template(:new)
        end

        it 'returns unprocessable entity status' do
          post :create, params: { user: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'assigns the user with errors' do
          post :create, params: { user: invalid_attributes }
          expect(assigns(:user)).to be_a(User)
          expect(assigns(:user)).not_to be_persisted
          expect(assigns(:user).errors).not_to be_empty
        end
      end

      context 'with user creation failure' do
        before do
          allow_any_instance_of(User).to receive(:save).and_return(false)
          allow_any_instance_of(User).to receive(:errors).and_return(double(empty?: false))
        end

        it 'renders new template' do
          post :create, params: { user: valid_attributes }
          expect(response).to render_template(:new)
        end

        it 'returns unprocessable entity status' do
          post :create, params: { user: valid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context 'when user is not admin' do
      before do
        allow(controller).to receive(:current_user).and_return(non_admin_user)
      end

      it 'redirects to root path' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(root_path)
      end

      it 'sets access denied alert' do
        post :create, params: { user: valid_attributes }
        expect(flash[:alert]).to eq(I18n.t('messages.access_denied'))
      end

      it 'does not create a user' do
        expect {
          post :create, params: { user: valid_attributes }
        }.not_to change(User, :count)
      end
    end
  end

  describe 'private methods' do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
    end

    describe '#user_params' do
      let(:params) do
        ActionController::Parameters.new(
          user: {
            email: 'test@example.com',
            name: 'Test User',
            matricula: '12345',
            role: 'aluno',
            password: 'password',
            password_confirmation: 'password',
            forbidden_param: 'should_not_be_permitted'
          }
        )
      end

      it 'permits only allowed parameters' do
        allow(controller).to receive(:params).and_return(params)
        
        permitted_params = controller.send(:user_params)
        
        expect(permitted_params.keys).to match_array(['email', 'name', 'matricula', 'role', 'password', 'password_confirmation'])
        expect(permitted_params['email']).to eq('test@example.com')
        expect(permitted_params['name']).to eq('Test User')
        expect(permitted_params['matricula']).to eq('12345')
        expect(permitted_params['role']).to eq('aluno')
        expect(permitted_params['password']).to eq('password')
        expect(permitted_params['password_confirmation']).to eq('password')
        expect(permitted_params).not_to have_key('forbidden_param')
      end
    end

    describe '#ensure_admin' do
      context 'when current user is admin' do
        it 'does not redirect' do
          allow(controller).to receive(:current_user).and_return(admin_user)
          expect(controller).not_to receive(:redirect_to)
          controller.send(:ensure_admin)
        end
      end

      context 'when current user is not admin' do
        let(:non_admin) { create(:user, role: 'aluno') }

        it 'redirects to root path' do
          allow(controller).to receive(:current_user).and_return(non_admin)
          expect(controller).to receive(:redirect_to).with(root_path, alert: I18n.t('messages.access_denied'))
          controller.send(:ensure_admin)
        end
      end
    end

    describe '#generate_temp_password' do
      it 'generates a password of 8 characters' do
        password = controller.send(:generate_temp_password)
        expect(password.length).to eq(8)
      end

      it 'generates different passwords on multiple calls' do
        password1 = controller.send(:generate_temp_password)
        password2 = controller.send(:generate_temp_password)
        expect(password1).not_to eq(password2)
      end

      it 'generates hexadecimal characters only' do
        password = controller.send(:generate_temp_password)
        expect(password).to match(/\A[0-9a-f]+\z/)
      end
    end
  end

  describe 'authentication and authorization flow' do
    it 'requires user authentication' do
      expect(controller).to receive(:authenticate_user!)
      get :new
    end

    it 'ensures admin role for new action' do
      allow(controller).to receive(:current_user).and_return(non_admin_user)
      expect(controller).to receive(:ensure_admin).and_call_original
      get :new
    end

    it 'ensures admin role for create action' do
      allow(controller).to receive(:current_user).and_return(non_admin_user)
      expect(controller).to receive(:ensure_admin).and_call_original
      post :create, params: { user: { email: 'test@example.com' } }
    end
  end
end
