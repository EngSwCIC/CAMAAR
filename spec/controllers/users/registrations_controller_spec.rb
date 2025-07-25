require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:admin_user) { create(:user, role: :admin) }
  let(:aluno_user) { create(:user, role: :aluno) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  # Testes usando requests diretos para exercitar o código real
  describe 'HTTP requests that exercise actual controller code' do
    # Testes diretos sem sign_in que causava problemas de mapping
    describe 'method calls via direct invocation' do
      it 'executes verificar_admin for admin user' do
        # Setup do controller
        controller_instance = described_class.new
        allow(controller_instance).to receive(:current_user).and_return(admin_user)
        allow(controller_instance).to receive(:request).and_return(request)
        
        # Execução real - admin deve ter acesso
        result = controller_instance.send(:verificar_admin)
        expect(result).to be_nil  # Método retorna nil quando permite acesso
      end

      it 'executes verificar_admin for non-admin user' do
        controller_instance = described_class.new
        allow(controller_instance).to receive(:current_user).and_return(aluno_user)
        allow(controller_instance).to receive(:flash).and_return(flash)
        allow(controller_instance).to receive(:redirect_to) { |path| path }
        allow(controller_instance).to receive(:root_path).and_return('/')
        
        # Execução real - não-admin deve ser redirecionado
        expect(controller_instance).to receive(:redirect_to).with('/')
        controller_instance.send(:verificar_admin)
      end

      it 'executes sign_up_params with valid parameters' do
        controller_instance = described_class.new
        
        # Simular params reais
        test_params = ActionController::Parameters.new(
          user: { 
            email: 'test@example.com', 
            password: 'password123', 
            password_confirmation: 'password123',
            role: 'aluno',
            name: 'Test User',
            matricula: '123456'
          }
        )
        
        allow(controller_instance).to receive(:params).and_return(test_params)
        
        # Execução real
        result = controller_instance.send(:sign_up_params)
        
        # Verificar que o código foi executado
        expect(result).to be_a(ActionController::Parameters)
        expect(result['email']).to eq('test@example.com')
        expect(result['name']).to eq('Test User')
        expect(result['matricula']).to eq('123456')
      end

      it 'executes account_update_params with valid parameters' do
        controller_instance = described_class.new
        
        test_params = ActionController::Parameters.new(
          user: { 
            email: 'updated@example.com', 
            password: 'newpassword123', 
            password_confirmation: 'newpassword123',
            current_password: 'oldpassword',
            name: 'Updated Name',
            matricula: '654321'
          }
        )
        
        allow(controller_instance).to receive(:params).and_return(test_params)
        
        # Execução real
        result = controller_instance.send(:account_update_params)
        
        expect(result).to be_a(ActionController::Parameters)
        expect(result['email']).to eq('updated@example.com')
        expect(result['name']).to eq('Updated Name')
      end

      it 'executes configure_sign_up_params' do
        controller_instance = described_class.new
        sanitizer = double('sanitizer')
        
        allow(controller_instance).to receive(:devise_parameter_sanitizer).and_return(sanitizer)
        expect(sanitizer).to receive(:permit).with(:sign_up, keys: %i[name role matricula])
        
        # Execução real
        controller_instance.send(:configure_sign_up_params)
      end

      it 'executes configure_account_update_params' do
        controller_instance = described_class.new
        sanitizer = double('sanitizer')
        
        allow(controller_instance).to receive(:devise_parameter_sanitizer).and_return(sanitizer)
        expect(sanitizer).to receive(:permit).with(:account_update, keys: %i[name matricula])
        
        # Execução real
        controller_instance.send(:configure_account_update_params)
      end

      it 'executes after_sign_up_path_for' do
        controller_instance = described_class.new
        user_instance = build(:user)
        
        # Mock users_path
        allow(controller_instance).to receive(:users_path).and_return('/users')
        
        # Execução real
        result = controller_instance.send(:after_sign_up_path_for, user_instance)
        expect(result).to eq('/users')
      end

      it 'executes after_inactive_sign_up_path_for' do
        controller_instance = described_class.new
        user_instance = build(:user)
        
        # Mock users_path
        allow(controller_instance).to receive(:users_path).and_return('/users')
        
        # Execução real
        result = controller_instance.send(:after_inactive_sign_up_path_for, user_instance)
        expect(result).to eq('/users')
      end
    end
  end

  # Testes com uso manual de ActionController::TestCase para forçar execução
  describe 'manual controller invocation' do
    let(:controller_instance) { described_class.new }

    before do
      # Setup mais completo para simular ambiente de controller
      allow(controller_instance).to receive(:request).and_return(request)
      allow(controller_instance).to receive(:response).and_return(response)
      allow(controller_instance).to receive(:session).and_return(session)
      allow(controller_instance).to receive(:flash).and_return(flash)
    end

    it 'calls new method implementation parts without Devise dependency' do
      # Setup para new method sem depender do Devise
      user_instance = User.new
      
      # Mock build_resource e resource para simular comportamento do Devise
      expect(controller_instance).to receive(:build_resource).with({}).and_return(user_instance)
      allow(controller_instance).to receive(:resource).and_return(user_instance)
      expect(controller_instance).to receive(:respond_with).with(user_instance)
      
      # Execução real do método new
      controller_instance.new
      
      # Verificar que role foi definido
      expect(user_instance.role).to eq('aluno')
    end

    it 'calls create method logic without Devise resource' do
      # Setup simples para testar lógica do create
      user_instance = build(:user)
      
      # Mock build_resource, resource e outros métodos necessários
      allow(controller_instance).to receive(:build_resource).and_return(user_instance)
      allow(controller_instance).to receive(:resource).and_return(user_instance)
      allow(controller_instance).to receive(:sign_up_params).and_return(
        ActionController::Parameters.new(email: 'test@test.com').permit!
      )
      
      # Teste quando save é bem-sucedido
      allow(user_instance).to receive(:save).and_return(true)
      allow(controller_instance).to receive(:users_path).and_return('/users')
      expect(controller_instance).to receive(:redirect_to).with('/users')
      
      # Execução real
      controller_instance.create
      
      # Verificar flash message foi definida
      expect(flash[:notice]).to eq('Usuário criado com sucesso!')
    end

    it 'calls create method failure path' do
      # Setup
      user_instance = build(:user)
      allow(user_instance).to receive(:save).and_return(false)
      
      # Mocks necessários incluindo o método resource
      allow(controller_instance).to receive(:build_resource).and_return(user_instance)
      allow(controller_instance).to receive(:resource).and_return(user_instance)
      allow(controller_instance).to receive(:sign_up_params).and_return(
        ActionController::Parameters.new.permit!
      )
      allow(controller_instance).to receive(:clean_up_passwords)
      allow(controller_instance).to receive(:set_minimum_password_length)
      
      # Expectativas  
      expect(controller_instance).to receive(:render).with(:new, status: :unprocessable_entity)
      
      # Execução real
      controller_instance.create
    end
  end

  # Testes de error paths e edge cases
  describe 'error handling and edge cases' do
    let(:controller_instance) { described_class.new }

    it 'handles ParameterMissing in sign_up_params' do
      params_without_user = ActionController::Parameters.new(other: 'value')
      allow(controller_instance).to receive(:params).and_return(params_without_user)
      
      # Execução real que deve gerar erro
      expect { controller_instance.send(:sign_up_params) }.to raise_error(ActionController::ParameterMissing)
    end

    it 'handles ParameterMissing in account_update_params' do
      params_without_user = ActionController::Parameters.new(other: 'value')
      allow(controller_instance).to receive(:params).and_return(params_without_user)
      
      # Execução real que deve gerar erro
      expect { controller_instance.send(:account_update_params) }.to raise_error(ActionController::ParameterMissing)
    end

    it 'handles nil current_user in verificar_admin' do
      allow(controller_instance).to receive(:current_user).and_return(nil)
      allow(controller_instance).to receive(:flash).and_return(flash)
      allow(controller_instance).to receive(:root_path).and_return('/')
      
      expect(controller_instance).to receive(:redirect_to).with('/')
      
      # Execução real
      controller_instance.send(:verificar_admin)
      expect(flash[:alert]).to eq('Acesso negado. Apenas administradores podem cadastrar novos usuários.')
    end

    it 'filters dangerous parameters in sign_up_params' do
      dangerous_params = ActionController::Parameters.new(
        user: { 
          email: 'test@example.com',
          password: 'password123',
          role: 'admin',
          name: 'Test User',
          matricula: '12345',  # Este é permitido
          dangerous_field: 'should_be_filtered',
          admin: true
        }
      )
      
      allow(controller_instance).to receive(:params).and_return(dangerous_params)
      
      # Execução real
      result = controller_instance.send(:sign_up_params)
      
      # Verificar filtragem - matricula deve estar incluído agora
      expect(result.keys).not_to include('dangerous_field', 'admin')
      expect(result.keys).to include('email', 'password', 'role', 'name', 'matricula')
    end
  end

  # Testes de configuração e herança
  describe 'controller configuration' do
    it 'has correct inheritance hierarchy' do
      expect(described_class.superclass).to eq(Devise::RegistrationsController)
      expect(described_class.ancestors).to include(ActionController::Base)
    end

    it 'has correct before_action callbacks configured' do
      callbacks = described_class._process_action_callbacks
      
      verificar_admin_callback = callbacks.find { |cb| cb.filter == :verificar_admin }
      expect(verificar_admin_callback).not_to be_nil
      expect(verificar_admin_callback.kind).to eq(:before)
      
      configure_sign_up_callback = callbacks.find { |cb| cb.filter == :configure_sign_up_params }
      expect(configure_sign_up_callback).not_to be_nil
      
      configure_account_update_callback = callbacks.find { |cb| cb.filter == :configure_account_update_params }
      expect(configure_account_update_callback).not_to be_nil
    end

    it 'defines all expected instance methods' do
      expect(described_class.instance_methods(false)).to include(:new, :create)
    end

    it 'defines all expected private methods' do
      private_methods = described_class.private_instance_methods(false)
      expect(private_methods).to include(:verificar_admin)
      expect(private_methods).to include(:sign_up_params)
      expect(private_methods).to include(:account_update_params)
      expect(private_methods).to include(:configure_sign_up_params)
      expect(private_methods).to include(:configure_account_update_params)
      expect(private_methods).to include(:after_sign_up_path_for)
      expect(private_methods).to include(:after_inactive_sign_up_path_for)
    end
  end

  # Testes adicionais de cobertura
  describe 'additional coverage tests' do
    let(:controller_instance) { described_class.new }

    it 'handles different parameter types correctly' do
      # Teste com role como integer
      int_params = ActionController::Parameters.new(
        user: { email: 'test@example.com', role: 1, matricula: 123456 }
      )
      allow(controller_instance).to receive(:params).and_return(int_params)
      
      result = controller_instance.send(:sign_up_params)
      expect(result['role']).to eq(1)
      expect(result['matricula']).to eq(123456)
    end

    it 'handles empty string parameters' do
      empty_params = ActionController::Parameters.new(
        user: { email: '', name: '', password: '', matricula: '' }
      )
      allow(controller_instance).to receive(:params).and_return(empty_params)
      
      result = controller_instance.send(:sign_up_params)
      expect(result['email']).to eq('')
      expect(result['name']).to eq('')
    end

    it 'properly initializes controller instance' do
      expect(described_class.new).to be_an_instance_of(Users::RegistrationsController)
      expect(described_class.new).to be_a(Devise::RegistrationsController)
    end

    it 'verifies method visibility' do
      instance = described_class.new
      
      # Public methods
      expect(instance).to respond_to(:new)
      expect(instance).to respond_to(:create)
      
      # Private methods should not be accessible publicly
      expect { instance.verificar_admin }.to raise_error(NoMethodError)
      expect { instance.sign_up_params }.to raise_error(NoMethodError)
    end
  end
end
