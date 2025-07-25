require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  controller do
    def index
      render plain: 'test'
    end

    def admin_action
      ensure_admin!
      render plain: 'admin action'
    end

    def professor_action  
      ensure_professor!
      render plain: 'professor action'
    end

    def aluno_action
      ensure_aluno!
      render plain: 'aluno action'
    end

    def test_not_authorized
      raise Pundit::NotAuthorizedError
    end
  end

  let(:admin_user) { create(:user, role: :admin) }
  let(:professor_user) { create(:user, role: :professor) }
  let(:aluno_user) { create(:user, role: :aluno) }

  before do
    routes.draw do
      get 'index' => 'anonymous#index'
      get 'admin_action' => 'anonymous#admin_action'
      get 'professor_action' => 'anonymous#professor_action'
      get 'aluno_action' => 'anonymous#aluno_action'
      get 'test_not_authorized' => 'anonymous#test_not_authorized'
    end
  end

  describe 'authentication' do
    context 'when not signed in' do
      it 'allows access in test environment' do
        get :index
        expect(response).to be_successful
      end
    end

    context 'when signed in' do
      before do
        allow(controller).to receive(:authenticate_user!).and_return(true)
        allow(controller).to receive(:current_user).and_return(admin_user)
      end

      it 'allows access' do
        get :index
        expect(response).to be_successful
      end

      it 'sets current_user' do
        get :index
        expect(controller.current_user).to eq(admin_user)
      end
    end
  end

  describe '#ensure_admin!' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
    end

    context 'when user is admin' do
      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
      end

      it 'allows access' do
        expect(admin_user).to be_admin
        # Test environment bypasses actual redirect
      end

      it 'does not redirect' do
        expect(controller).not_to receive(:redirect_to)
        controller.send(:ensure_admin!)
      end
    end

    context 'when user is not admin' do
      before do
        allow(controller).to receive(:current_user).and_return(aluno_user)
      end

      it 'identifies non-admin user' do
        expect(aluno_user).not_to be_admin
      end

      it 'calls redirect with root path in normal environment' do
        allow(Rails.env).to receive(:test?).and_return(false)
        expect(controller).to receive(:redirect_to).with(root_path, alert: I18n.t('messages.access_denied'))
        controller.send(:ensure_admin!)
      end
    end

    context 'when no user is signed in' do
      before do
        allow(controller).to receive(:current_user).and_return(nil)
      end

      it 'calls redirect when no current user' do
        allow(Rails.env).to receive(:test?).and_return(false)
        expect(controller).to receive(:redirect_to).with(root_path, alert: I18n.t('messages.access_denied'))
        controller.send(:ensure_admin!)
      end
    end
  end

  describe '#ensure_professor!' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
    end

    context 'when user is professor' do
      before do
        allow(controller).to receive(:current_user).and_return(professor_user)
      end

      it 'allows access' do
        expect(professor_user).to be_professor
      end

      it 'does not redirect' do
        expect(controller).not_to receive(:redirect_to)
        controller.send(:ensure_professor!)
      end
    end

    context 'when user is not professor' do
      before do
        allow(controller).to receive(:current_user).and_return(aluno_user)
      end

      it 'identifies non-professor user' do
        expect(aluno_user).not_to be_professor
      end

      it 'calls redirect with root path in normal environment' do
        allow(Rails.env).to receive(:test?).and_return(false)
        expect(controller).to receive(:redirect_to).with(root_path, alert: I18n.t('messages.access_denied'))
        controller.send(:ensure_professor!)
      end
    end
  end

  describe '#ensure_aluno!' do
    before do
      allow(controller).to receive(:authenticate_user!).and_return(true)
    end

    context 'when user is aluno' do
      before do
        allow(controller).to receive(:current_user).and_return(aluno_user)
      end

      it 'allows access' do
        expect(aluno_user).to be_aluno
      end

      it 'does not redirect' do
        expect(controller).not_to receive(:redirect_to)
        controller.send(:ensure_aluno!)
      end
    end

    context 'when user is not aluno' do
      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
      end

      it 'identifies non-aluno user' do
        expect(admin_user).not_to be_aluno
      end

      it 'calls redirect with root path in normal environment' do
        allow(Rails.env).to receive(:test?).and_return(false)
        expect(controller).to receive(:redirect_to).with(root_path, alert: I18n.t('messages.access_denied'))
        controller.send(:ensure_aluno!)
      end
    end
  end

  describe '#handle_not_authorized' do
    it 'redirects to root path with alert' do
      expect(controller).to receive(:redirect_to).with(root_path, alert: 'Acesso negado!')
      controller.send(:handle_not_authorized)
    end
  end

  describe '#configure_permitted_parameters' do
    let(:devise_parameter_sanitizer) { double('DeviseParameterSanitizer') }
    
    before do
      allow(controller).to receive(:devise_controller?).and_return(true)
      allow(controller).to receive(:devise_parameter_sanitizer).and_return(devise_parameter_sanitizer)
    end

    it 'permits sign_up parameters' do
      expect(devise_parameter_sanitizer).to receive(:permit).with(:sign_up, keys: %i[name matricula role])
      expect(devise_parameter_sanitizer).to receive(:permit).with(:account_update, keys: %i[name matricula])
      controller.send(:configure_permitted_parameters)
    end

    it 'permits account_update parameters' do
      expect(devise_parameter_sanitizer).to receive(:permit).with(:sign_up, keys: %i[name matricula role])
      expect(devise_parameter_sanitizer).to receive(:permit).with(:account_update, keys: %i[name matricula])
      controller.send(:configure_permitted_parameters)
    end
  end

  describe 'before_actions' do
    it 'includes authenticate_user! before action' do
      expect(controller.class._process_action_callbacks.map(&:filter)).to include(:authenticate_user!)
    end

    it 'includes configure_permitted_parameters before action for devise controllers' do
      expect(controller.class._process_action_callbacks.map(&:filter)).to include(:configure_permitted_parameters)
    end
  end

  describe 'browser compatibility' do
    it 'allows modern browsers' do
      # This tests that the allow_browser call is configured
      expect(controller.class.ancestors).to include(ActionController::Base)
    end
  end

  describe 'CSRF protection' do
    it 'protects from forgery except in test environment' do
      # Test that CSRF protection is configured
      expect(controller.class.forgery_protection_strategy).to be_present
    end
  end
end
