# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrimeiraSenhaController, type: :controller do
  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  let(:user_without_password) do
    user = build(:user)
    user.encrypted_password = ''
    user.save(validate: false)
    user
  end
  let(:user_with_password) { create(:user, password: 'password123') }

  describe 'GET #new' do
    it 'returns a successful response' do
      get :new
      expect(response).to be_successful
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with missing parameters' do
      it 'handles missing matricula' do
        post :create, params: {
          email: user_without_password.email,
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Por favor, preencha todos os campos obrigatórios.')
      end

      it 'handles missing email' do
        post :create, params: {
          matricula: user_without_password.matricula,
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Por favor, preencha todos os campos obrigatórios.')
      end

      it 'handles missing password' do
        post :create, params: {
          matricula: user_without_password.matricula,
          email: user_without_password.email,
          password_confirmation: 'newpassword123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Por favor, informe a senha e sua confirmação.')
      end

      it 'handles missing password confirmation' do
        post :create, params: {
          matricula: user_without_password.matricula,
          email: user_without_password.email,
          password: 'newpassword123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Por favor, informe a senha e sua confirmação.')
      end
    end

    context 'with password validation errors' do
      it 'handles password mismatch' do
        post :create, params: {
          matricula: user_without_password.matricula,
          email: user_without_password.email,
          password: 'newpassword123',
          password_confirmation: 'differentpassword'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('As senhas não coincidem.')
      end

      it 'handles password too short' do
        post :create, params: {
          matricula: user_without_password.matricula,
          email: user_without_password.email,
          password: '123',
          password_confirmation: '123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('A senha deve ter pelo menos 6 caracteres.')
      end
    end

    context 'with user not found' do
      it 'handles invalid matricula' do
        post :create, params: {
          matricula: 'invalid_matricula',
          email: user_without_password.email,
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Usuário não encontrado. Verifique sua matrícula e email.')
      end

      it 'handles invalid email' do
        post :create, params: {
          matricula: user_without_password.matricula,
          email: 'invalid@email.com',
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Usuário não encontrado. Verifique sua matrícula e email.')
      end
    end

    context 'with user who already has password' do
      it 'prevents password reset for users with existing password' do
        post :create, params: {
          matricula: user_with_password.matricula,
          email: user_with_password.email,
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Este usuário já possui uma senha definida. Use a opção "Esqueci minha senha" se necessário.')
      end
    end

    context 'with valid parameters for user without password' do
      before do
        # Create user without password by directly manipulating encrypted_password
        user_without_password.update_column(:encrypted_password, '')
      end

      it 'successfully sets the first password' do
        post :create, params: {
          matricula: user_without_password.matricula,
          email: user_without_password.email,
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:notice]).to eq('Senha definida com sucesso! Agora você pode fazer login.')
      end

      it 'updates the user password' do
        post :create, params: {
          matricula: user_without_password.matricula,
          email: user_without_password.email,
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        user_without_password.reload
        expect(user_without_password.valid_password?('newpassword123')).to be true
      end
    end

    context 'when password setting fails' do
      before do
        user_without_password.update_column(:encrypted_password, '')
        allow_any_instance_of(User).to receive(:definir_primeira_senha).and_return(false)
      end

      it 'handles password setting failure' do
        post :create, params: {
          matricula: user_without_password.matricula,
          email: user_without_password.email,
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash.now[:alert]).to eq('Erro ao definir senha. Tente novamente.')
      end
    end

    context 'parameter sanitization' do
      it 'strips whitespace from matricula and email' do
        user_without_password.update_column(:encrypted_password, '')

        post :create, params: {
          matricula: "  #{user_without_password.matricula}  ",
          email: "  #{user_without_password.email.upcase}  ",
          password: 'newpassword123',
          password_confirmation: 'newpassword123'
        }

        expect(response).to redirect_to(new_user_session_path)
        expect(flash[:notice]).to eq('Senha definida com sucesso! Agora você pode fazer login.')
      end
    end
  end
end
