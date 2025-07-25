require 'rails_helper'

RSpec.describe Admin::ManagementController, type: :controller do
  let(:admin_user) { create(:user, role: 'admin') }
  let(:non_admin_user) { create(:user, role: 'aluno') }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
  end

  describe 'GET #index' do
    context 'when user is admin' do
      before do
        allow(controller).to receive(:current_user).and_return(admin_user)
        allow(controller).to receive(:authorize).and_return(true)
      end

      it 'returns a success response' do
        get :index
        expect(response).to be_successful
      end

      it 'assigns @has_imported_data when data exists' do
        allow(controller).to receive(:imported_data_exists?).and_return(true)
        get :index
        expect(assigns(:has_imported_data)).to be true
      end

      it 'assigns @has_imported_data when no data exists' do
        allow(controller).to receive(:imported_data_exists?).and_return(false)
        get :index
        expect(assigns(:has_imported_data)).to be false
      end
    end

    context 'when user is not admin' do
      before do
        allow(controller).to receive(:current_user).and_return(non_admin_user)
      end

      it 'allows access to index (authorization handled by policies)' do
        get :index
        expect(response).to be_successful
      end
    end
  end

# Note: import_modal action doesn't exist in the controller, removing this test

  describe 'POST #import_users' do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
      allow(controller).to receive(:authorize).and_return(true)
    end

    context 'with valid JSON file' do
      let(:file) { fixture_file_upload('test_users.json', 'application/json') }
      let(:valid_json) { '[{"name": "Test User", "email": "test@example.com"}]' }
      let(:import_result) { { success: true, imported: 1, skipped: 0 } }

      before do
        allow(File).to receive(:read).and_return(valid_json)
        allow(JSON).to receive(:parse).and_call_original
        allow(ImportService).to receive(:import_users).and_return(import_result)
      end

      it 'imports users successfully' do
        post :import_users, params: { file: file }
        
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include(
          'success' => true,
          'imported_count' => 1,
          'skipped_count' => 0
        )
      end

      it 'calls ImportService with correct data' do
        expect(ImportService).to receive(:import_users).with(JSON.parse(valid_json))
        post :import_users, params: { file: file }
      end
    end

    context 'with invalid JSON file' do
      let(:file) { fixture_file_upload('invalid.json', 'application/json') }

      before do
        allow(File).to receive(:read).and_return('invalid json')
        allow(JSON).to receive(:parse).with('invalid json').and_raise(JSON::ParserError)
        allow(JSON).to receive(:parse).and_call_original
      end

      it 'returns error for invalid JSON' do
        post :import_users, params: { file: file }
        
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include(
          'success' => false,
          'message' => 'Arquivo JSON inválido'
        )
      end
    end

    context 'when ImportService returns error' do
      let(:file) { fixture_file_upload('test_users.json', 'application/json') }
      let(:valid_json) { '[{"name": "Test User"}]' }
      let(:import_result) { { success: false, error: 'Import failed' } }

      before do
        allow(File).to receive(:read).and_return(valid_json)
        allow(JSON).to receive(:parse).and_call_original
        allow(ImportService).to receive(:import_users).and_return(import_result)
      end

      it 'returns the service error' do
        post :import_users, params: { file: file }
        
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include(
          'success' => false,
          'message' => 'Import failed'
        )
      end
    end

    context 'when file operation raises error' do
      let(:file) { fixture_file_upload('test_users.json', 'application/json') }

      before do
        allow(File).to receive(:read).and_raise(StandardError.new('File read error'))
      end

      it 'handles the error gracefully' do
        post :import_users, params: { file: file }
        
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include(
          'success' => false,
          'message' => 'Erro: File read error'
        )
      end
    end

    context 'without file parameter' do
      it 'returns error message' do
        post :import_users
        
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include(
          'success' => false,
          'message' => 'Nenhum arquivo foi enviado'
        )
      end
    end
  end

  describe 'POST #import_disciplines' do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
      allow(controller).to receive(:authorize).and_return(true)
    end

    context 'with valid JSON file' do
      let(:file) { fixture_file_upload('test_disciplines.json', 'application/json') }
      let(:valid_json) { '[{"nome": "Test Discipline", "curso": "Test Course"}]' }
      let(:import_result) { { success: true, imported: 1, skipped: 0 } }

      before do
        allow(File).to receive(:read).and_return(valid_json)
        allow(JSON).to receive(:parse).and_call_original
        allow(ImportService).to receive(:import_disciplines).and_return(import_result)
      end

      it 'imports disciplines successfully' do
        post :import_disciplines, params: { file: file }
        
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include(
          'success' => true,
          'imported_count' => 1,
          'skipped_count' => 0
        )
      end

      it 'calls ImportService with correct data' do
        expect(ImportService).to receive(:import_disciplines).with(JSON.parse(valid_json))
        post :import_disciplines, params: { file: file }
      end
    end

    context 'with invalid JSON file' do
      let(:file) { fixture_file_upload('invalid.json', 'application/json') }

      before do
        allow(File).to receive(:read).and_return('invalid json')
        allow(JSON).to receive(:parse).with('invalid json').and_raise(JSON::ParserError)
        allow(JSON).to receive(:parse).and_call_original
      end

      it 'returns error for invalid JSON' do
        post :import_disciplines, params: { file: file }
        
        expect(response).to have_http_status(:ok)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include(
          'success' => false,
          'message' => 'Arquivo JSON inválido'
        )
      end
    end

    context 'when ImportService returns error' do
      let(:file) { fixture_file_upload('test_disciplines.json', 'application/json') }
      let(:valid_json) { '[{"nome": "Test Discipline"}]' }
      let(:import_result) { { success: false, error: 'Discipline import failed' } }

      before do
        allow(File).to receive(:read).and_return(valid_json)
        allow(JSON).to receive(:parse).and_call_original
        allow(ImportService).to receive(:import_disciplines).and_return(import_result)
      end

      it 'returns the service error' do
        post :import_disciplines, params: { file: file }
        
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include(
          'success' => false,
          'message' => 'Discipline import failed'
        )
      end
    end

    context 'without file parameter' do
      it 'returns error message' do
        post :import_disciplines
        
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to include(
          'success' => false,
          'message' => 'Nenhum arquivo foi enviado'
        )
      end
    end
  end

  describe 'private methods' do
    before do
      allow(controller).to receive(:current_user).and_return(admin_user)
      allow(controller).to receive(:authorize).and_return(true)
    end

    describe '#imported_data_exists?' do
      it 'returns true when imported data exists' do
        create(:user, email: 'imported@example.com')
        create(:disciplina)
        
        get :index
        expect(controller.send(:imported_data_exists?)).to be true
      end

      it 'returns false when no imported data exists' do
        # Clear any existing data
        User.destroy_all
        Disciplina.destroy_all
        
        get :index
        expect(controller.send(:imported_data_exists?)).to be false
      end

      it 'excludes seed users from count' do
        User.destroy_all
        Disciplina.destroy_all
        
        # Create seed users
        create(:user, email: 'admin@camaar.com')
        create(:user, email: 'coordenador@camaar.com')
        
        get :index
        expect(controller.send(:imported_data_exists?)).to be false
      end

      it 'requires both users and disciplines to exist' do
        User.destroy_all
        Disciplina.destroy_all
        
        # Only users, no disciplines
        create(:user, email: 'imported@example.com')
        
        get :index
        expect(controller.send(:imported_data_exists?)).to be false
      end
    end

    describe '#authorize_management' do
      it 'calls authorize with correct parameters' do
        expect(controller).to receive(:authorize).with([:admin, :management], :index?)
        controller.send(:authorize_management)
      end
    end

    describe '#authorize_import_users' do
      it 'calls authorize with correct parameters' do
        expect(controller).to receive(:authorize).with([:admin, :management], :import_users?)
        controller.send(:authorize_import_users)
      end
    end

    describe '#authorize_import_disciplines' do
      it 'calls authorize with correct parameters' do
        expect(controller).to receive(:authorize).with([:admin, :management], :import_disciplines?)
        controller.send(:authorize_import_disciplines)
      end
    end
  end
end
